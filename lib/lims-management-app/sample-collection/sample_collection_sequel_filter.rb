require 'lims-core/persistence/sequel/filters'
require 'lims-management-app/sample-collection/sample_collection_filter'

module Lims::Core
  module Persistence
    module Sequel::Filters
      include Virtus

      # @param [Hash] criteria
      # @return [Lims::Core::Persistence::Persistor]
      # Redefine multi_criteria_filter of Lims::Core::Persistence::Sequel::Filters.
      # A search using sample collection data potentially involves joining multiple tables
      # together and matching multiple lines in each joined table. This is NOT supported 
      # in the original multi_criteria_filter. We override here this method to apply 
      # data criteria filter when it's needed.
      alias :multi_criteria_filter_old :multi_criteria_filter
      def multi_criteria_filter(criteria)
        data_criteria = expand_data_criteria!(criteria)
        persistor = data_criteria.empty? ? self : collection_data_criteria_filter(data_criteria)
        persistor.multi_criteria_filter_old(criteria)
      end

      # @param [Hash] criteria
      # @return [Lims::Core::Persistence::Persistor]
      # The SQL we need finally for the search is for example:
      # select * from collections c
      # inner join collection_data_int cdi on cdi.collection_id = c.id
      # inner join collection_data_bool cdb on cdb.collection_id = c.id
      # where (cdi.key,cdi.value) in (("test",1), ("test2",2))
      # and (cdb.key,cdb.value) in (("bool",1),("bool2",1))
      # group by c.id having count(*) = 2*2;
      #
      # We need to join together all the collection_data_<type> tables which appear
      # in the criteria. Then we need to match all the criteria (key,value) for each
      # table. Finally, we group by collection_id for which the number of rows is equal
      # to the cartesian product of the criteria in each table (it's actually a relational
      # division). This having condition is enough to get the right result because there 
      # are unique constraint on (key, collection_id) in each collection_data_<type>.
      # So no duplicates which could error the having condition.
      # If not, we would need something like:
      # having count(distinct cdi.key) = 2 and count(distinct cdb.key) = 2.
      def collection_data_criteria_filter(criteria)
        qualify = lambda { |table, column| ::Sequel.qualify(table, column) }

        joined_filtered_dataset = criteria.reduce(self.dataset) do |dataset, (table, data)|
          dataset.join(
            table, :collection_id => qualify[self.table_name, self.primary_key]
        ).where(
          [qualify[table, :key], qualify[table, :value]] => [].tap { |compared_data|
            data.each { |d| compared_data << [d[:key], d[:value]] }
          }
        )
        end

        cartesian_product_joined_rows = criteria.reduce(1) do |num, (_, data)|
          num *= data.size
        end

        grouped_dataset = joined_filtered_dataset.group_and_count(
          qualify[self.table_name, self.primary_key]
        ).having({:count => cartesian_product_joined_rows})

        result_dataset = self.dataset.join(
          ::Sequel.as(grouped_dataset, :grouped_dataset), qualify[:grouped_dataset, self.primary_key] => qualify[self.table_name, self.primary_key]
        ).select_all(self.table_name)

        self.class.new(self, result_dataset)
      end

      # @param [Hash] criteria
      # @return [Hash]
      # This method deletes the data criteria found in the criteria hash
      # passed in parameter. It expands the data criteria to have a hash like:
      # {:table_name => [{:key => "criterion key", :value => "criterion value"}]}
      # Table names correspond to collection_data_<type>. The type is automatically
      # infered depending on the criterion value.
      def expand_data_criteria!(criteria)
        {}.tap do |data_criteria|
          if criteria.has_key?(:data)
            criteria.delete(:data).each do |data|
              key, value = data["key"], data["value"]
              type = type_discovery(value)
              table = "collection_data_#{type}".to_sym
              data_criteria[table] ||= []
              data_criteria[table] << {:key => key, :value => value}
            end
          end
        end
      end

      # TODO: Move type discovery in data_types.rb and use it for sample collection creation
      def type_discovery(value)
        case value
        when Integer then "int"
        when TrueClass then "bool"
        when FalseClass then "bool"
        when Lims::ManagementApp::SampleCollection::ValidationShared::VALID_URL_PATTERN then "url"
        when Lims::ManagementApp::SampleCollection::ValidationShared::VALID_UUID_PATTERN then "uuid"
        else "string"
        end
      end
     
      def sample_collection_filter(criteria)
        criteria = criteria[:sample_collection] if criteria.keys.first.to_s == "sample_collection"
        criteria.rekey! { |k| k.to_sym }

        sample_collection_persistor = @session.sample_collection.__multi_criteria_filter(expanded_criteria(criteria))
        sample_collection_dataset = sample_collection_persistor.dataset.join(
          :collections_samples, :collection_id => :collections__id
        )

        debugger
        self.class.new(self, dataset.join(sample_collection_dataset, :sample_id => :samples__id).qualify.distinct)
      end
    end
  end
end
require 'lims-management-app/sample/sample_persistor'
require 'lims-core/persistence/sequel/persistor'

module Lims::ManagementApp
  class Sample
    class SampleSequelPersistor < Sample::SamplePersistor
      include Lims::Core::Persistence::Sequel::Persistor

      def self.table_name
        :samples
      end

      private

      # @param [Object] object
      # @param [Integer] id
      # @param [Arguments] params
      # @return [Integer]
      # Override lims-core sequel/persistor#delete_raw.
      # After a sample is deleted, we need to delete
      # the DNA, RNA, Cellular Material it references 
      # with its foreign keys. We need to first delete
      # the sample object to verify the constraints.
      def delete_raw(object, id, *params)
        sample_id = super
        components = [object.dna, object.rna, object.cellular_material, object.genotyping]
        components.each do |component|
          if component
            persistor = @session.persistor_for(component)
            persistor_dataset = persistor.dataset
            persistor_dataset.filter(persistor.primary_key => persistor.id_for(component)).delete
          end
        end
        sample_id
      end

      # @param [String] sample_type
      # @return [Integer,Nil]
      def sample_type_id(sample_type)
        if sample_type
          sample_type_object = self.dataset.from(:sample_types).where(:type => sample_type).first
          sample_type_object[:id]
        end
      end

      # @param [Integer] sample_type_id
      # @return [String,Nil]
      def sample_type(sample_type_id)
        if sample_type_id
          sample_type_object = self.dataset.from(:sample_types).where(:id => sample_type_id).first 
          sample_type_object[:type]
        end
      end

      # @param [Integer] taxon_id
      # @param [String] name
      # @param [String] type
      # @return [Integer,Nil]
      # Return the taxonomy id based on the taxon id, 
      # the name and type in parameters.
      # If an exception is raised, the save is cancelled
      # and the transaction rollbacked.
      def taxonomy_primary_id(taxon_id, name, type)
        if taxon_id
          persistor = @session.persistor_for(:taxonomy)
          raise UnknownTaxonIdError, "Taxon ID #{taxon_id} unknown" unless persistor.valid_taxon_id?(taxon_id, type)

          id = persistor.id_by_taxon_id_and_name(taxon_id, name, type)
          raise NameTaxonIdMismatchError, "Taxon ID #{taxon_id} does not match the #{type} '#{name}'. Do you mean '#{persistor.name_by_taxon_id(taxon_id, type)}'?" unless id 
          id
        end
      end
    end
  end
end

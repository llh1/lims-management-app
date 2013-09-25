require 'lims-core/persistence/persistor'

module Lims::ManagementApp
  class SampleCollection
    class SampleCollectionPersistor < Lims::Core::Persistence::Persistor
      Model = SampleCollection

      def save_children(id, collection)
        collection.samples.each do |sample|
          collection_sample.save_as_association(id, sample) 
        end
      end

      def load_children(id, collection)
        collection_sample.load_samples(id) do |sample|
          collection.samples << sample
        end
      end

      def filter_attributes_on_save(attributes)
        attributes.delete(:samples)
        attributes
      end

      def collection_sample
        @session.collection_sample
      end
    end

    class CollectionSample
      SESSION_NAME = :collection_sample
      class CollectionSamplePersistor < Lims::Core::Persistence::Persistor
      end
    end
  end
end
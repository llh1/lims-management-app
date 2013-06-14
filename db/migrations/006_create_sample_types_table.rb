Sequel.migration do
  up do
    create_table :sample_types do
      primary_key :id
      String :type
      index :type
    end

    # Seeds
    self[:sample_types].tap do |t|
      [
        "DNA Human", "DNA Pathogen", "RNA", "Blood", 
        "Saliva", "Tissue Non-Tumour", "Tissue Tumour", 
        "Pathogen", "Cell Pellet"
      ].each do |type|
        t.insert(:type => type)
      end
    end

    # Add a column sample_type_id in samples
    alter_table :samples do
      add_foreign_key :sample_type_id, :sample_types, :key => :id
    end

    # Migrate sample_type content to the new sample_type_id column
    self[:samples].all do |sample|
      sample_type_id = self[:sample_types].where(:type => sample[:sample_type]).first[:id]
      self[:samples].where(:id => sample[:id]).update(:sample_type_id => sample_type_id)
    end

    # Delete sample_id column in samples table
    alter_table :samples do
      drop_column :sample_type
    end
  end

  down do
    alter_table :samples do
      drop_column :sample_type_id
      add_column :sample_type, String
    end

    drop_table :sample_types
  end
end

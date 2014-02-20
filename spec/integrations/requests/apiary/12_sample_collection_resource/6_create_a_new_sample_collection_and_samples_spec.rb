require "integrations/requests/apiary/12_sample_collection_resource/spec_helper"
describe "create_a_new_sample_collection_and_samples", :sample_collection => true do
  include_context "use core context service"
  it "create_a_new_sample_collection_and_samples" do

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/sample_collections", <<-EOD
    {
    "sample_collection": {
        "type": "Study",
        "samples": {
            "sanger_sample_id_core": "S2",
            "quantity": 3,
            "gender": "Male",
            "sample_type": "RNA",
            "taxon_id": 9606,
            "volume": 100,
            "date_of_sample_collection": "2013-04-25 10:27 UTC",
            "is_sample_a_control": true,
            "disease_phenotype": "normal",
            "age_band": "45-60",
            "is_re_submitted_sample": false,
            "hmdmc_number": "number",
            "supplier_sample_name": "name",
            "common_name": "human",
            "scientific_name": "homo sapiens",
            "ebi_accession_number": "number",
            "sample_source": "source",
            "mother": "mother",
            "father": "father",
            "sibling": "sibling",
            "gc_content": "content",
            "public_name": "name",
            "cohort": "cohort",
            "storage_conditions": "conditions",
            "dna": {
                "pre_amplified": true,
                "date_of_sample_extraction": "2013-04-25 11:10 UTC",
                "extraction_method": "method",
                "concentration": 20,
                "sample_purified": false,
                "concentration_determined_by_which_method": "method"
            },
            "rna": {
                "pre_amplified": true,
                "date_of_sample_extraction": "2013-04-25 11:10 UTC",
                "extraction_method": "method",
                "concentration": 20,
                "sample_purified": false,
                "concentration_determined_by_which_method": "method"
            },
            "cellular_material": {
                "lysed": true,
                "donor_id": "donor id"
            },
            "genotyping": {
                "country_of_origin": "England",
                "geographical_region": "UK",
                "ethnicity": "english"
            }
        },
        "data": [
            {
                "key": "key_string",
                "type": "string",
                "value": "value string"
            },
            {
                "key": "key_bool",
                "value": true
            },
            {
                "key": "key_bool2",
                "type": "bool",
                "value": false
            },
            {
                "key": "key_uuid",
                "type": "uuid",
                "value": "11111111-0000-0000-0000-000000000000"
            },
            {
                "key": "key_url",
                "value": "http://www.sanger.ac.uk"
            },
            {
                "key": "key_int",
                "type": "int",
                "value": 123
            }
        ]
    }
}
    EOD
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "sample_collection": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-888888888888",
            "create": "http://example.org/11111111-2222-3333-4444-888888888888",
            "update": "http://example.org/11111111-2222-3333-4444-888888888888",
            "delete": "http://example.org/11111111-2222-3333-4444-888888888888"
        },
        "uuid": "11111111-2222-3333-4444-888888888888",
        "type": "Study",
        "data": {
            "key_string": "value string",
            "key_bool": true,
            "key_bool2": false,
            "key_uuid": "11111111-0000-0000-0000-000000000000",
            "key_url": "http://www.sanger.ac.uk",
            "key_int": 123
        },
        "samples": [
            {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "state": "draft",
                "supplier_sample_name": "name",
                "gender": "Male",
                "sanger_sample_id": "S2-1",
                "sample_type": "RNA",
                "scientific_name": "homo sapiens",
                "common_name": "human",
                "hmdmc_number": "number",
                "disease_phenotype": "normal",
                "age_band": "45-60",
                "ebi_accession_number": "number",
                "sample_source": "source",
                "mother": "mother",
                "father": "father",
                "sibling": "sibling",
                "gc_content": "content",
                "public_name": "name",
                "cohort": "cohort",
                "storage_conditions": "conditions",
                "taxon_id": 9606,
                "volume": 100,
                "date_of_sample_collection": "2013-04-25T10:27:00+00:00",
                "is_sample_a_control": true,
                "is_re_submitted_sample": false,
                "dna": {
                    "pre_amplified": true,
                    "date_of_sample_extraction": "2013-04-25T11:10:00+00:00",
                    "extraction_method": "method",
                    "concentration": 20,
                    "sample_purified": false,
                    "concentration_determined_by_which_method": "method"
                },
                "rna": {
                    "pre_amplified": true,
                    "date_of_sample_extraction": "2013-04-25T11:10:00+00:00",
                    "extraction_method": "method",
                    "concentration": 20,
                    "sample_purified": false,
                    "concentration_determined_by_which_method": "method"
                },
                "cellular_material": {
                    "lysed": true,
                    "donor_id": "donor id"
                },
                "genotyping": {
                    "country_of_origin": "England",
                    "geographical_region": "UK",
                    "ethnicity": "english"
                }
            },
            {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                },
                "uuid": "11111111-2222-3333-4444-666666666666",
                "state": "draft",
                "supplier_sample_name": "name",
                "gender": "Male",
                "sanger_sample_id": "S2-2",
                "sample_type": "RNA",
                "scientific_name": "homo sapiens",
                "common_name": "human",
                "disease_phenotype": "normal",
                "age_band": "45-60",
                "hmdmc_number": "number",
                "ebi_accession_number": "number",
                "sample_source": "source",
                "mother": "mother",
                "father": "father",
                "sibling": "sibling",
                "gc_content": "content",
                "public_name": "name",
                "cohort": "cohort",
                "storage_conditions": "conditions",
                "taxon_id": 9606,
                "volume": 100,
                "date_of_sample_collection": "2013-04-25T10:27:00+00:00",
                "is_sample_a_control": true,
                "is_re_submitted_sample": false,
                "dna": {
                    "pre_amplified": true,
                    "date_of_sample_extraction": "2013-04-25T11:10:00+00:00",
                    "extraction_method": "method",
                    "concentration": 20,
                    "sample_purified": false,
                    "concentration_determined_by_which_method": "method"
                },
                "rna": {
                    "pre_amplified": true,
                    "date_of_sample_extraction": "2013-04-25T11:10:00+00:00",
                    "extraction_method": "method",
                    "concentration": 20,
                    "sample_purified": false,
                    "concentration_determined_by_which_method": "method"
                },
                "cellular_material": {
                    "lysed": true,
                    "donor_id": "donor id"
                },
                "genotyping": {
                    "country_of_origin": "England",
                    "geographical_region": "UK",
                    "ethnicity": "english"
                }
            },
            {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                    "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                    "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                    "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                },
                "uuid": "11111111-2222-3333-4444-777777777777",
                "state": "draft",
                "supplier_sample_name": "name",
                "gender": "Male",
                "sanger_sample_id": "S2-3",
                "sample_type": "RNA",
                "scientific_name": "homo sapiens",
                "common_name": "human",
                "hmdmc_number": "number",
                "ebi_accession_number": "number",
                "sample_source": "source",
                "mother": "mother",
                "father": "father",
                "sibling": "sibling",
                "gc_content": "content",
                "public_name": "name",
                "cohort": "cohort",
                "disease_phenotype": "normal",
                "age_band": "45-60",
                "storage_conditions": "conditions",
                "taxon_id": 9606,
                "volume": 100,
                "date_of_sample_collection": "2013-04-25T10:27:00+00:00",
                "is_sample_a_control": true,
                "is_re_submitted_sample": false,
                "dna": {
                    "pre_amplified": true,
                    "date_of_sample_extraction": "2013-04-25T11:10:00+00:00",
                    "extraction_method": "method",
                    "concentration": 20,
                    "sample_purified": false,
                    "concentration_determined_by_which_method": "method"
                },
                "rna": {
                    "pre_amplified": true,
                    "date_of_sample_extraction": "2013-04-25T11:10:00+00:00",
                    "extraction_method": "method",
                    "concentration": 20,
                    "sample_purified": false,
                    "concentration_determined_by_which_method": "method"
                },
                "cellular_material": {
                    "lysed": true,
                    "donor_id": "donor id"
                },
                "genotyping": {
                    "country_of_origin": "England",
                    "geographical_region": "UK",
                    "ethnicity": "english"
                }
            }
        ]
    }
}
    EOD

  end
end
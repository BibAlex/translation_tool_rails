class CreateNewDb < ActiveRecord::Migration
  
  def self.up
    # encoding: UTF-8
    # This file is auto-generated from the current state of the database. Instead
    # of editing this file, please use the migrations feature of Active Record to
    # incrementally modify your database, and then regenerate this schema definition.
    #
    # Note that this schema.rb definition is the authoritative source for your
    # database schema. If you need to create the application database on another
    # system, you should be using db:schema:load, not running all the migrations
    # from scratch. The latter is a flawed and unsustainable approach (the more migrations
    # you'll amass, the slower it'll run and the greater likelihood for issues).
    #
    # It's strongly recommended to check this file into your version control system.
    # DROP TABLE IF EXISTS 'Unique_DO';
    create_table "Unique_DO", :id => false, :force => true do |t|
      t.integer "data_object_id", :null => false
    end
    
    # DROP TABLE IF EXISTS 'a_data_objects';
    create_table "a_data_objects", :force => true do |t|
      t.integer  "user_id",                                    :null => false
      t.integer  "process_id",                                 :null => false
      t.string   "object_title",           :limit => 500
      t.string   "rights_statement",       :limit => 500
      t.string   "rights_holder",          :limit => 500
      t.text     "description",            :limit => 16777215
      t.datetime "modified_at"
      t.boolean  "locked"
      t.integer  "taxon_concept_id"
      t.string   "location",               :limit => 500
      t.integer  "update_status_id"
    end
    
    # DROP TABLE IF EXISTS 'a_names';
    create_table "a_names", :force => true do |t|
      t.integer  "taxon_id",                                           :null => false
      t.string   "name",                 :limit => 400,                :null => false
      t.integer  "created_by",                                         :null => false
      t.datetime "creation_date",                                      :null => false
      t.integer  "last_modified_person",                               :null => false
      t.datetime "last_modified_date",                                 :null => false
      t.integer  "name_status_id",                      :default => 2, :null => false
    end
  
    # DROP TABLE IF EXISTS 'archived_a_data_objects';
    create_table "archived_a_data_objects", :force => true do |t|
      t.integer  "data_object_id"
      t.integer  "user_id"
      t.integer  "process_id"
      t.string   "object_title",     :limit => 500
      t.string   "rights_statement", :limit => 500
      t.string   "rights_holder",    :limit => 500
      t.text     "description",      :limit => 16777215
      t.datetime "modified_at"
      t.boolean  "locked"
      t.integer  "taxon_concept_id"
      t.string   "location",         :limit => 500
    end
  
    # DROP TABLE IF EXISTS 'conditions';
    create_table "conditions", :force => true do |t|
      t.string "name", :limit => 45
    end
  
    # DROP TABLE IF EXISTS 'countries';
    create_table "countries", :force => true do |t|
      t.string "name", :limit => 80, :default => "", :null => false
    end
  
    # DROP TABLE IF EXISTS 'data_objects';
    create_table "data_objects", :force => true do |t|
      t.string    "guid",                   :limit => 32
      t.string    "identifier"
      t.integer   "data_type_id",           :limit => 2
      t.integer   "mime_type_id",           :limit => 2
      t.string    "object_title"
      t.integer   "language_id",            :limit => 2
      t.integer   "license_id",             :limit => 1
      t.string    "rights_statement",       :limit => 300
      t.string    "rights_holder"
      t.string    "bibliographic_citation", :limit => 300
      t.string    "source_url"
      t.text      "description",            :limit => 16777215
      t.text      "description_linked",     :limit => 16777215
      t.string    "object_url"
      t.integer   "object_cache_url",       :limit => 8
      t.string    "thumbnail_url"
      t.integer   "thumbnail_cache_url",    :limit => 8
      t.string    "location"
      t.float     "latitude"
      t.float     "longitude"
      t.float     "altitude"
      t.timestamp "object_created_at",                                             :null => false
      t.timestamp "object_modified_at",                                            :null => false
      t.timestamp "created_at",                                                    :null => false
      t.timestamp "updated_at",                                                    :null => false
      t.float     "data_rating",                                :default => 2.5
      t.integer   "vetted_id",              :limit => 1
      t.integer   "visibility_id"
      t.boolean   "published",                                  :default => false
      t.boolean   "curated",                                    :default => false
      t.boolean   "aeol_translation"
      t.integer   "words_count"
      t.integer   "harvest_batch_id"
      t.integer   "harvest_batch_type"
      t.boolean   "hidden",                                     :default => false
      t.integer   "parent_data_object_id"
    end
    add_index "data_objects", ["created_at"], :name => "created_at"
    add_index "data_objects", ["data_type_id"], :name => "data_type_id"
    add_index "data_objects", ["description"], :name => "description", :length => {"description"=>250}
    add_index "data_objects", ["guid"], :name => "index_data_objects_on_guid"
    add_index "data_objects", ["identifier"], :name => "identifier"
    add_index "data_objects", ["object_url"], :name => "object_url"
    add_index "data_objects", ["published"], :name => "index_data_objects_on_published"
    add_index "data_objects", ["visibility_id"], :name => "index_data_objects_on_visibility_id"
  
    # DROP TABLE IF EXISTS 'data_objects_info_items';
    create_table "data_objects_info_items", :id => false, :force => true do |t|
      t.integer "data_object_id",              :null => false
      t.integer "info_item_id",   :limit => 2, :null => false
    end
    add_index "data_objects_info_items", ["info_item_id"], :name => "info_item_id"
  
    # DROP TABLE IF EXISTS 'data_objects_table_of_contents';
    create_table "data_objects_table_of_contents", :id => false, :force => true do |t|
      t.integer "data_object_id",              :null => false
      t.integer "toc_id",         :limit => 2, :null => false
    end
  
    # DROP TABLE IF EXISTS 'data_objects_taxon_concepts';
    create_table "data_objects_taxon_concepts", :id => false, :force => true do |t|
      t.integer "taxon_concept_id", :null => false
      t.integer "data_object_id",   :null => false
    end
    add_index "data_objects_taxon_concepts", ["data_object_id"], :name => "data_object_id"
  
    # DROP TABLE IF EXISTS 'data_types';
    create_table "data_types", :force => true do |t|
      t.string "schema_value",               :null => false
      t.string "label",                      :null => false
      t.string "type",         :limit => 45, :null => false
    end
    add_index "data_types", ["label"], :name => "label"
  
    # DROP TABLE IF EXISTS 'glossariers';
    create_table "glossaries", :primary_key => "letter", :force => true do |t|
      t.text "text"
    end
  
    # DROP TABLE IF EXISTS 'harvest_batch_type';
    create_table "harvest_batch_type", :force => true do |t|
      t.string "name", :limit => 45
    end
  
    # DROP TABLE IF EXISTS 'info_items';
    create_table "info_items", :force => true do |t|
      t.string  "schema_value",              :null => false
      t.string  "label",                     :null => false
      t.integer "toc_id",       :limit => 2, :null => false
    end
    add_index "info_items", ["label"], :name => "label"
  
    # DROP TABLE IF EXISTS 'licenses';
    create_table "licenses", :force => true do |t|
      t.string  "title",                                                      :null => false
      t.string  "description",              :limit => 400,                    :null => false
      t.string  "source_url",                                                 :null => false
      t.string  "version",                  :limit => 6,                      :null => false
      t.string  "logo_url",                                                   :null => false
      t.boolean "show_to_content_partners",                :default => false, :null => false
    end
    add_index "licenses", ["source_url"], :name => "source_url"
    add_index "licenses", ["title"], :name => "title"
  
    # DROP TABLE IF EXISTS 'mime_types';
    create_table "mime_types", :force => true do |t|
      t.string "label", :null => false
    end
    add_index "mime_types", ["label"], :name => "label"
  
    # DROP TABLE IF EXISTS 'name_languages';
    create_table "name_languages", :id => false, :force => true do |t|
      t.integer "name_id",                     :null => false
      t.integer "language_id",    :limit => 2, :null => false
      t.integer "parent_name_id",              :null => false
      t.integer "preferred",      :limit => 1, :null => false
    end
    add_index "name_languages", ["parent_name_id"], :name => "parent_name_id"
  
    # DROP TABLE IF EXISTS 'name_status';
    create_table "name_status", :force => true do |t|
      t.string "name", :limit => 45, :null => false
    end
  
    # DROP TABLE IF EXISTS 'names';
    create_table "names", :force => true do |t|
      t.integer "namebank_id",                        :null => false
      t.string  "string",              :limit => 300, :null => false
      t.string  "clean_name",          :limit => 300, :null => false
      t.string  "italicized",          :limit => 300, :null => false
      t.integer "italicized_verified", :limit => 1,   :null => false
      t.integer "canonical_form_id",                  :null => false
      t.integer "canonical_verified",  :limit => 1,   :null => false
    end
    add_index "names", ["canonical_form_id"], :name => "canonical_form_id"
    add_index "names", ["clean_name"], :name => "clean_name", :length => {"clean_name"=>255}
  
    # DROP TABLE IF EXISTS 'priorities';
    create_table "priorities", :force => true do |t|
      t.string  "label",      :limit => 150
      t.integer "sort_order",                :default => 0
      t.integer "is_default", :limit => 1,   :default => 0
    end
  
    # DROP TABLE IF EXISTS 'selection_batches';
    create_table "selection_batches", :force => true do |t|
      t.text     "criteria"
      t.string   "comments",         :limit => 500, :default => "", :null => false
      t.datetime "date_selected",                                   :null => false
      t.datetime "date_distributed",                                :null => false
      t.integer  "user_id",                         :default => 0,  :null => false
      t.integer  "finished",         :limit => 1,   :default => 0,  :null => false
      t.integer  "hierarchy_id",                    :default => 0,  :null => false
      t.integer  "priority_id",                     :default => 3
    end
  
    # DROP TABLE IF EXISTS 'status';
    create_table "status", :force => true do |t|
      t.string "label", :limit => 45, :default => "", :null => false
      t.boolean "directly_assigned",  :default => false, :null => false
    end
  
    # DROP TABLE IF EXISTS 'table_of_contents';
    create_table "table_of_contents", :force => true do |t|
      t.integer "parent_id",  :limit => 2,                :null => false
      t.string  "label",                                  :null => false
      t.integer "view_order", :limit => 2, :default => 0
    end
    add_index "table_of_contents", ["label"], :name => "label"
  
    # DROP TABLE IF EXISTS 'taxon_concept_assign_logs';
    create_table "taxon_concept_assign_logs", :force => true do |t|
      t.integer   "taxon_concept_id"
      t.integer   "user_id"
      t.integer   "phase_id"
      t.timestamp "assign_date"
      t.timestamp "finish_date"
      t.integer   "by_user_id"
    end
  
    # DROP TABLE IF EXISTS 'taxon_concept_names';
    create_table "taxon_concept_names", :id => false, :force => true do |t|
      t.integer  "taxon_concept_id",                       :default => 0, :null => false
      t.integer  "name_id",                                               :null => false
      t.integer  "source_hierarchy_entry_id",                             :null => false
      t.integer  "language_id",                                           :null => false
      t.integer  "vern",                      :limit => 1,                :null => false
      t.integer  "preferred",                 :limit => 1,                :null => false
      t.integer  "synonym_id"
      t.integer  "vetted_id"
      t.integer  "name_status_id",                         :default => 1
      t.datetime "last_modified_date"
      t.integer  "last_modified_person"
    end
    add_index "taxon_concept_names", ["name_id"], :name => "name_id"
    add_index "taxon_concept_names", ["source_hierarchy_entry_id"], :name => "source_hierarchy_entry_id"
    add_index "taxon_concept_names", ["synonym_id"], :name => "index_taxon_concept_names_on_synonym_id"
    add_index "taxon_concept_names", ["vern"], :name => "vern"
  
    # DROP TABLE IF EXISTS 'taxon_concepts';
    create_table "taxon_concepts", :force => true do |t|
      t.integer  "supercedure_id",                                           :null => false
      t.integer  "split_from",                                               :null => false
      t.integer  "vetted_id",              :limit => 1,   :default => 0,     :null => false
      t.integer  "published",              :limit => 1,   :default => 0,     :null => false
      t.integer  "selection_id",                          :default => 0,     :null => false
      t.integer  "taxon_status_id",                       :default => 0,     :null => false
      t.string   "scientificName",         :limit => 500, :default => "'",   :null => false
      t.datetime "selection_date"
      t.datetime "publish_date"
      t.boolean  "taxon_update",                                             :null => false
    end
    add_index "taxon_concepts", ["published"], :name => "published"
    add_index "taxon_concepts", ["selection_id"], :name => "FK_taxon_concepts_selection_batches"
    add_index "taxon_concepts", ["supercedure_id"], :name => "supercedure_id"
  
    # DROP TABLE IF EXISTS 'templates';
    create_table "templates", :force => true do |t|
      t.string  "name_en",        :limit => 1000
      t.string  "name_ar",        :limit => 1000
      t.boolean "IsRightsHolder"
    end
  
    # DROP TABLE IF EXISTS 'update_status';
    create_table "update_status", :force => true do |t|
      t.string "name", :limit => 200
    end
  
    # DROP TABLE IF EXISTS 'updated_data_objects';
    create_table "updated_data_objects", :force => true do |t|
      t.string    "guid",                   :limit => 32
      t.string    "identifier"
      t.integer   "data_type_id",           :limit => 2
      t.integer   "mime_type_id",           :limit => 2
      t.string    "object_title"
      t.integer   "language_id",            :limit => 2
      t.integer   "license_id",             :limit => 1
      t.string    "rights_statement",       :limit => 300
      t.string    "rights_holder"
      t.string    "bibliographic_citation", :limit => 300
      t.string    "source_url"
      t.text      "description",            :limit => 16777215
      t.text      "description_linked",     :limit => 16777215
      t.string    "object_url"
      t.integer   "object_cache_url",       :limit => 8
      t.string    "thumbnail_url"
      t.integer   "thumbnail_cache_url",    :limit => 8
      t.string    "location"
      t.float     "latitude"
      t.float     "longitude"
      t.float     "altitude"
      t.timestamp "object_created_at",                                             :null => false
      t.timestamp "object_modified_at",                                            :null => false
      t.timestamp "created_at",                                                    :null => false
      t.timestamp "updated_at",                                                    :null => false
      t.float     "data_rating",                                :default => 2.5
      t.integer   "vetted_id",              :limit => 1
      t.integer   "visibility_id"
      t.boolean   "published",                                  :default => false
      t.boolean   "curated",                                    :default => false
      t.integer   "harvested_batch_id"
    end
  
    # DROP TABLE IF EXISTS 'updated_data_objects_taxon_concepts';
    create_table "updated_data_objects_taxon_concepts", :id => false, :force => true do |t|
      t.integer "taxon_concept_id",   :null => false
      t.integer "data_object_id",     :null => false
      t.integer "harvested_batch_id"
    end
    add_index "updated_data_objects_taxon_concepts", ["data_object_id"], :name => "data_object_id"
  
    # DROP TABLE IF EXISTS 'updated_harvest_batches';
    create_table "updated_harvest_batches", :force => true do |t|
      t.datetime "harvest_date"
    end
  
    # DROP TABLE IF EXISTS 'users';
    create_table "users", :force => true do |t|
      t.string  "name",                :limit => 150, :default => "", :null => false
      t.string  "username",            :limit => 50,  :default => "", :null => false
      t.string  "password",            :limit => 50,  :default => "", :null => false
      t.integer "super_admin",         :limit => 1,   :default => 0,  :null => false
      t.integer "active",              :limit => 1,   :default => 0,  :null => false
      t.integer "selector",              :limit => 1,   :default => 0,  :null => false
      t.string  "email",               :limit => 100, :default => "", :null => false
      t.integer "country_id",                         :default => 0,  :null => false
      t.integer "it_admin",            :limit => 1,   :default => 0
    end
    
    # DROP TABLE IF EXISTS 'users_status';
    create_table "users_status", :force => true do |t|
      t.integer "user_id", :null => false
      t.integer "status_id", :null => false
    end
  end
end

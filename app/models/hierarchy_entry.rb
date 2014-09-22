class HierarchyEntry < ActiveRecord::Base
  #HierarchyEntry.establish_connection("eol_data_#{Rails.env}")
  
  belongs_to :hierarchy
  
  attr_accessible :id, :siblings_count, :taxon_concept, :taxon_concept_id, :parent_id, :hierarchy

  def self.find_siblings(hierarchy_id, parent_id)
    HierarchyEntry.establish_connection(:adapter  => "mysql2",
                                        :host     => "localhost",
                                        :username => "root",
                                        :password => "root",
                                        :database => "#{MASTER}_#{Rails.env}")
    HierarchyEntry.find_by_sql("select string as taxon_concept, h1.id, h1.parent_id, 
                            (select count(*) from hierarchy_entries as h2 where h2.parent_id=h1.id) as siblings_count, 
                            h1.taxon_concept_id
                          from hierarchy_entries h1
                            left outer join names on names.id=name_id
                          where hierarchy_id=#{hierarchy_id} and parent_id=#{parent_id} and published=1 order by taxon_concept;")
  end
  
  def clean_taxon_concept
    taxon_concept.gsub("\n"," ").gsub("\'", "\\\'")
  end
  
  def self.get_name(id)
    HierarchyEntry.establish_connection(:adapter  => "mysql2",
                                        :host     => "localhost",
                                        :username => "root",
                                        :password => "root",
                                        :database => "#{MASTER}_#{Rails.env}")
    if id
     hierarchy_entry =  HierarchyEntry.find_by_sql("select string from hierarchy_entries h1
                                                    left outer join names on names.id=name_id
                                                    where h1.id=#{id} and published=1;")
     hierarchy_entry.first.string
    else
      ""   
    end
  end
  
  def self.search(hierarchy_id, hierarchy_entry_id,
                  have_text, text_curated, vetted_text_array,
                  have_images, images_curated, vetted_images_array,
                  select_sub, select_hotlist)
     
     HierarchyEntry.establish_connection(:adapter  => "mysql2",
                                        :host     => "localhost",
                                        :username => "root",
                                        :password => "root",
                                        :database => "#{MASTER}_#{Rails.env}")
                                            
    rgt = 0
    lft = 0
    records = HierarchyEntry.find_by_sql("select rgt,lft from hierarchy_entries where id=#{hierarchy_entry_id};");
    if (records.count() > 0)
      rgt = records[0].rgt
      lft = records[0].lft
    end
    
    
    query_str = "select string, he.id, he.taxon_concept_id,
                 (select count(distinct data_objects.id) from data_objects
                  inner join data_objects_table_of_contents
                  ON data_objects_table_of_contents.data_object_id=data_objects.id
                  inner join table_of_contents
                  ON table_of_contents.id=data_objects_table_of_contents.toc_id
                  inner join data_objects_taxon_concepts dotc
                  ON dotc.data_object_id=data_objects.id
                  inner join data_objects_hierarchy_entries dohe
                  On dohe.data_object_id=data_objects.id
                  where dotc.taxon_concept_id=he.taxon_concept_id
                  and dohe.visibility_id<> #{VISIBILITY_INVISIBLE}
                  and language_id= #{LANGUAGE_EN}
                  and data_type_id= #{DATA_TYPES_TEXT}
                  and data_objects.published=1
                  and
                  (
                  toc_id in (#{TOC_INCLUDED_PARENT_IDS})
                  or
                  table_of_contents.parent_id in (#{TOC_INCLUDED_PARENT_IDS}))) as total_text_objects,
                  (select count(distinct(data_objects.id)) from data_objects
                  Inner join top_concept_images tc on tc.data_object_id=data_objects.id
                  Inner join data_objects_hierarchy_entries dohe on dohe.data_object_id=data_objects.id
                  where language_id=#{LANGUAGE_EN}
                  and published=1
                  and tc.taxon_concept_id=he.taxon_concept_id
                  and dohe.visibility_id<>#{VISIBILITY_INVISIBLE}) as total_image_objects,
                  (select count(distinct data_objects.id) from data_objects
                  inner join data_objects_taxon_concepts dotc
                  ON dotc.data_object_id=data_objects.id
                  inner join data_objects_hierarchy_entries dohe
                  On dohe.data_object_id=data_objects.id
                  where dotc.taxon_concept_id=he.taxon_concept_id
                  and dohe.visibility_id<>#{VISIBILITY_INVISIBLE}
                  and language_id=#{LANGUAGE_EN}
                  and (data_type_id in (#{DATA_TYPES_MEDIA}))
                  and data_objects.published=1
                  and published=1) as total_other_objects
                  from hierarchy_entries he "
                  
    query_str += "left outer join names on names.id=name_id "
    
    if (select_hotlist == 1)
      query_str += "inner join hotlists_hierarchy_entries on hotlists_hierarchy_entries.hierarchy_entry_id=he.id "
    end
    
    query_str += "where hierarchy_id= #{hierarchy_id.to_s} "
    
    if (select_sub == 1)
      query_str += "and (he.id= #{hierarchy_entry_id.to_s} or (he.lft>= #{lft.to_s} and he.rgt<= #{rgt.to_s})) "
    else
      query_str += "and (he.id= #{hierarchy_entry_id.to_s} or (he.lft= #{lft.to_s} and he.rgt= #{rgt.to_s})) "
    end
    
    if (have_text == 0)
      query_str +=   "and not exists (select * from data_objects
                     inner join data_objects_table_of_contents
                     ON data_objects_table_of_contents.data_object_id=data_objects.id
                     inner join table_of_contents
                     ON table_of_contents.id=data_objects_table_of_contents.toc_id
                     inner join data_objects_taxon_concepts dotc
                     ON dotc.data_object_id=data_objects.id
                     inner join data_objects_hierarchy_entries dohe
                     On dohe.data_object_id=data_objects.id
                     where dotc.taxon_concept_id=he.taxon_concept_id
                     and dohe.visibility_id<> #{VISIBILITY_INVISIBLE}
                     and language_id= #{LANGUAGE_EN}
                     and data_type_id=#{DATA_TYPES_TEXT}
                     and data_objects.published=1
                     and
                     (
                     toc_id in (#{TOC_INCLUDED_PARENT_IDS})
                     or
                     table_of_contents.parent_id in (#{TOC_INCLUDED_PARENT_IDS}))) "
    end
    
    if (have_text == 1)
      query_str +=   "and exists (select * from data_objects
                     inner join data_objects_table_of_contents
                     ON data_objects_table_of_contents.data_object_id=data_objects.id
                     inner join table_of_contents
                     ON table_of_contents.id=data_objects_table_of_contents.toc_id
                     inner join data_objects_taxon_concepts dotc
                     ON dotc.data_object_id=data_objects.id
                     inner join data_objects_hierarchy_entries dohe
                     On dohe.data_object_id=data_objects.id
                     where dotc.taxon_concept_id=he.taxon_concept_id
                     and dohe.visibility_id<>#{VISIBILITY_INVISIBLE}
                     and language_id=#{LANGUAGE_EN}
                     and data_type_id=#{DATA_TYPES_TEXT}
                     and data_objects.published=1
                     and
                     (
                     toc_id in (#{TOC_INCLUDED_PARENT_IDS})
                     or
                     table_of_contents.parent_id in (#{TOC_INCLUDED_PARENT_IDS}))) "
    end
    
    if (have_text != 0) 
      if ((text_curated && text_curated.to_i > -1) || (vetted_text_array && vetted_text_array.count != 3)) 
        query_str +=   "and exists (select * from data_objects
                       inner join data_objects_table_of_contents
                       ON data_objects_table_of_contents.data_object_id=data_objects.id
                       inner join table_of_contents
                       ON table_of_contents.id=data_objects_table_of_contents.toc_id
                       inner join data_objects_taxon_concepts dotc
                       ON dotc.data_object_id=data_objects.id
                       inner join data_objects_hierarchy_entries dohe
                       On dohe.data_object_id=data_objects.id
                       where dotc.taxon_concept_id=he.taxon_concept_id
                       and dohe.visibility_id<>#{VISIBILITY_INVISIBLE}
                       and language_id=#{LANGUAGE_EN}
                       and data_type_id=#{DATA_TYPES_TEXT}
                       and data_objects.published=1
                       and
                       (
                       toc_id in (#{TOC_INCLUDED_PARENT_IDS})
                       or
                       table_of_contents.parent_id in (#{TOC_INCLUDED_PARENT_IDS})) "
        if (text_curated && text_curated.to_i > -1)
          query_str += "and curated= #{text_curated.to_s} "
        end
        
        if (vetted_text_array && vetted_text_array.count != 3) 
          query_str += "and (vetted_id>-1 "
          (0..vetted_text_array.count - 1).each do |i|
            query_str +=  " or vetted_id= #{vetted_text_array[i]} "
          end
          query_str += ") "
        end
        query_str += ") "
      end
    end
    
    if (have_images == 0)
      query_str +=   "and not exists (select * from data_objects
                     Inner join top_images on data_object_id=data_objects.id
                     inner join data_objects_hierarchy_entries dohe
                     ON dohe.data_object_id=data_objects.id
                     where top_images.hierarchy_entry_id=he.id
                     and language_id=#{LANGUAGE_EN}
                     and published=1 and dohe.visibility_id=#{VISIBILITY_INVISIBLE}) "
    end
    
    if (have_images == 1)
      query_str +=  "and exists (select * from data_objects
                     Inner join top_images on data_object_id=data_objects.id
                     inner join data_objects_hierarchy_entries dohe
                     ON dohe.data_object_id=data_objects.id
                     where top_images.hierarchy_entry_id=he.id
                     and language_id=#{LANGUAGE_EN}
                     and published=1 and dohe.visibility_id=#{VISIBILITY_INVISIBLE}) "
    end
    
    if (have_images != 0) 
      if ((images_curated && images_curated.to_i > -1) || (vetted_images_array && vetted_images_array.count != 3)) 
        query_str +=   "and exists (select * from data_objects
                       Inner join top_images on data_object_id=data_objects.id
                       inner join data_objects_hierarchy_entries dohe
                       ON dohe.data_object_id=data_objects.id
                       where top_images.hierarchy_entry_id=he.id
                       and language_id=#{LANGUAGE_EN}
                       and published=1 and dohe.visibility_id=#{VISIBILITY_INVISIBLE} "
        if (images_curated.to_i > -1)
          query_str += "and curated=#{images_curated.to_s} "
        end
        
        if (vetted_images_array && vetted_images_array.count != 3) 
          query_str += "and (vetted_id>-1 "
          (0..vetted_images_array.count - 1).each do |i|
            query_str += "or vetted_id= #{vetted_images_array[i]} "
          end
          query_str += ") "
        end
        query_str += ") "
      end
    end
    
    query_str += " order by string"
    HierarchyEntry.find_by_sql(query_str)
  end
end

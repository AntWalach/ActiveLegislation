# frozen_string_literal: true

# This migration comes from acts_as_taggable_on_engine (originally 2)
class AddMissingUniqueIndices < ActiveRecord::Migration[7.1]
  def self.up
    add_index ActsAsTaggableOn.tags_table, :name, unique: true

    if ActiveRecord::Base.connection.adapter_name.downcase.starts_with?('mysql')
      # Pomijamy usuwanie indeksu na :tag_id w MySQL, aby uniknąć błędu
    else
      remove_index ActsAsTaggableOn.taggings_table, :tag_id if index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    end

    if index_exists?(ActsAsTaggableOn.taggings_table, nil, name: 'taggings_taggable_context_idx')
      remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx'
    end

    unless index_exists?(ActsAsTaggableOn.taggings_table, %i[tag_id taggable_id taggable_type context tagger_id tagger_type], name: 'taggings_idx')
      add_index ActsAsTaggableOn.taggings_table,
                %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
                unique: true, name: 'taggings_idx'
    end
  end

  def self.down
    remove_index ActsAsTaggableOn.tags_table, name: 'index_tags_on_name'

    if index_exists?(ActsAsTaggableOn.taggings_table, nil, name: 'taggings_idx')
      remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_idx'
    end

    unless index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
      add_index ActsAsTaggableOn.taggings_table, :tag_id
    end

    unless index_exists?(ActsAsTaggableOn.taggings_table, %i[taggable_id taggable_type context], name: 'taggings_taggable_context_idx')
      add_index ActsAsTaggableOn.taggings_table, %i[taggable_id taggable_type context],
                name: 'taggings_taggable_context_idx'
    end
  end
end

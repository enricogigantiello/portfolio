class AddThumbnailDataToReferenceLinks < ActiveRecord::Migration[8.1]
  def change
    add_column :reference_links, :thumbnail_data, :jsonb
  end
end

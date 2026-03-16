class AddThumbnailDataColumnsToReferenceLinks < ActiveRecord::Migration[8.1]
  def change
    add_column :reference_links, :title, :string
    add_column :reference_links, :description, :text
    add_column :reference_links, :image, :string
    add_column :reference_links, :favicon, :string
  end
end

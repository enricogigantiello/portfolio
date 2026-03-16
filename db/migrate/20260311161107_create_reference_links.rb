class CreateReferenceLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :reference_links do |t|
      t.references :project, null: false, foreign_key: true
      t.string :link_type
      t.string :url
      t.string :label
      t.integer :position

      t.timestamps
    end
  end
end

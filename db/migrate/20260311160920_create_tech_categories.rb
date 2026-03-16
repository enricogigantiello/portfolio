class CreateTechCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :tech_categories do |t|
      t.string :name
      t.string :category_type

      t.timestamps
    end
  end
end

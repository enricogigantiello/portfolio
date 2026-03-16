class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages do |t|
      t.string :name
      t.string :level
      t.integer :position

      t.timestamps
    end
  end
end

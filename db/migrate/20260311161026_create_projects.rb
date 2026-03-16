class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :job, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :role
      t.integer :position

      t.timestamps
    end
  end
end

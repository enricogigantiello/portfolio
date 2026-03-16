class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :company
      t.text :description
      t.string :role
      t.date :start_date
      t.date :end_date
      t.integer :position

      t.timestamps
    end
  end
end

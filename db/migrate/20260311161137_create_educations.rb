class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.string :degree
      t.string :institution
      t.text :description
      t.date :start_date
      t.date :end_date
      t.decimal :grade
      t.decimal :grade_min
      t.decimal :grade_max
      t.integer :position

      t.timestamps
    end
  end
end

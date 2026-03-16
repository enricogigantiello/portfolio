class CreateProjectTeches < ActiveRecord::Migration[8.1]
  def change
    create_table :project_teches do |t|
      t.references :project, null: false, foreign_key: true
      t.references :tech, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end

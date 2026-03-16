class CreateProjectAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :project_achievements do |t|
      t.references :project, null: false, foreign_key: true
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end

class AddCommitCountsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :commit_counts, :jsonb
  end
end

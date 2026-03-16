class MakeReferenceLinksPolymorphic < ActiveRecord::Migration[8.1]
  def change
    # Add polymorphic columns
    add_column :reference_links, :referenceable_type, :string
    add_column :reference_links, :referenceable_id, :bigint

    # Migrate existing data from project_id
    reversible do |dir|
      dir.up do
        ReferenceLink.reset_column_information
        ReferenceLink.where.not(project_id: nil).update_all("referenceable_type = 'Project'")
        ReferenceLink.update_all("referenceable_id = project_id WHERE project_id IS NOT NULL")
      end
    end

    # Add index for polymorphic association
    add_index :reference_links, [ :referenceable_type, :referenceable_id ]

    # Add unique index for jobs (since a job can only have one reference_link)
    add_index :reference_links, [ :referenceable_type, :referenceable_id ],
              unique: true,
              where: "referenceable_type = 'Job'",
              name: "index_reference_links_unique_job"

    # Remove the old project_id column and foreign key
    remove_foreign_key :reference_links, :projects if foreign_key_exists?(:reference_links, :projects)
    remove_index :reference_links, name: "index_reference_links_on_project_id" if index_exists?(:reference_links, :project_id)
    remove_column :reference_links, :project_id
  end
end

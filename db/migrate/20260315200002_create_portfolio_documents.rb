class CreatePortfolioDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolio_documents do |t|
      t.text :content, null: false
      t.string :title
      t.string :source_type
      t.bigint :source_id
      t.string :chunk_type
      t.jsonb :metadata, default: {}
      t.vector :embedding, limit: 1536

      t.timestamps
    end

    add_index :portfolio_documents, [ :source_type, :source_id ]
    add_index :portfolio_documents, [ :source_type, :source_id, :chunk_type ],
              name: "index_portfolio_documents_on_source_and_chunk_type",
              unique: true
    add_index :portfolio_documents, :embedding,
              using: :hnsw,
              opclass: :vector_cosine_ops
  end
end

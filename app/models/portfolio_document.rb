class PortfolioDocument < ApplicationRecord
  has_neighbors :embedding

  belongs_to :source, polymorphic: true, optional: true

  before_save :generate_embedding, if: :content_changed?

  scope :search, ->(query, limit: 5) {
    query_embedding = RubyLLM.embed(query).vectors
    nearest_neighbors(:embedding, query_embedding, distance: :cosine).limit(limit)
  }

  private

  def generate_embedding
    return if content.blank?

    self.embedding = RubyLLM.embed(content).vectors
  rescue RubyLLM::Error => e
    errors.add(:base, "Failed to generate embedding: #{e.message}")
    throw :abort
  end
end

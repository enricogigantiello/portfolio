class Job < ApplicationRecord
  extend Mobility
  translates :title, :company, :role, type: :string
  translates :description, type: :text

  has_many :projects, dependent: :destroy
  accepts_nested_attributes_for :projects, allow_destroy: true
  has_one :reference_link, as: :referenceable, dependent: :destroy

  scope :ordered, -> { order(:position) }

  after_commit :reindex_for_rag

  private

  def reindex_for_rag
    PortfolioIndexJob.perform_later(self.class.name, id)
  end
end

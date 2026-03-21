class Project < ApplicationRecord
  extend Mobility
  translates :title, :role, type: :string
  translates :description, type: :text

  belongs_to :job
  has_many :project_techs, dependent: :destroy
  has_many :techs, through: :project_techs
  has_many :reference_links, as: :referenceable, dependent: :destroy
  has_many :project_achievements, dependent: :destroy

  has_one_attached :tile_image
  has_one_attached :cover_image

  accepts_nested_attributes_for :project_achievements, :reference_links, allow_destroy: true

  scope :ordered, -> { order(:position) }

  after_commit :reindex_for_rag

  private

  def reindex_for_rag
    PortfolioIndexJob.perform_later(self.class.name, id)
  end
end

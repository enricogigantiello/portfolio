class ReferenceLink < ApplicationRecord
  include FetchableUrlMetadata
  extend Mobility
  translates :label, type: :string

  belongs_to :referenceable, polymorphic: true

  enum :link_type, { project: "project", news: "news", job: "job" }

  validates :url, presence: true, format: { with: /\A#{URI.regexp}\z/ }
  scope :ordered, -> { order(:position) }

  before_save :parse_thumbnail_data

  private

  def parse_thumbnail_data
    if thumbnail_data.is_a?(String) && thumbnail_data.present?
      begin
        self.thumbnail_data = JSON.parse(thumbnail_data)
      rescue JSON::ParserError
        self.thumbnail_data = {}
      end
    end
  end
end

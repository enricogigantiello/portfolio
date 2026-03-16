# frozen_string_literal: true

module FetchableUrlMetadata
  extend ActiveSupport::Concern

  included do
    after_save :fetch_url_metadata, if: -> { url.present? && saved_change_to_url? }
  end

  def fetch_url_metadata
    debugger
    begin
      page = LinkThumbnailer.generate(url)
      self.update_column(:thumbnail_data, {
        title: page.title,
        description: page.description,
        images: page.images.map(&:src).uniq,
        videos: page.videos.map(&:src).uniq,
        favicon: page.favicon
      })

      self.update_column(:title, page.title) if page.title.present?
      self.update_column(:description, page.description) if page.description.present?
      self.update_column(:image, page.images.first) if page.images.any?
      self.update_column(:favicon, page.favicon) if page.favicon.present?
    rescue => e
      Rails.logger.error("Failed to fetch metadata for URL #{url}: #{e.message}")
    end
  end

  def populate_from_thumbnail_data
    return unless thumbnail_data.present?

    self.title ||= thumbnail_data["title"]
    self.description ||= thumbnail_data["description"]
    self.image ||= thumbnail_data["images"].first if thumbnail_data["images"].present?
    self.favicon ||= thumbnail_data["favicon"]

    self.save
  end
end

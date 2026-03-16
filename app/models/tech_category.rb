class TechCategory < ApplicationRecord
  has_many :techs, dependent: :destroy

  enum :category_type, {
    programming_language: "programming_language",
    framework: "framework",
    devops: "devops",
    database: "database",
    payment: "payment",
    ai: "ai",
    cloud_platform: "cloud_platform"
  }
end

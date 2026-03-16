module HomeHelper
  TECH_CATEGORY_ICONS = {
    "programming_language" => "bi bi-server",
    "framework"           => "bi bi-window",
    "web3"                => "bi bi-currency-bitcoin",
    "database"            => "bi bi-database",
    "devops"              => "bi bi-cloud",
    "payment"             => "bi bi-credit-card",
    "ai"                  => "bi bi-robot",
    "cloud_platform"      => "bi bi-cloud"
  }.freeze

  def tech_category_icon(category)
    TECH_CATEGORY_ICONS.fetch(category.category_type.to_s, "bi bi-cpu")
  end
end

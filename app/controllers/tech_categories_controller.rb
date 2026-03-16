class TechCategoriesController < ApplicationController
  def index
    @tech_categories = TechCategory.includes(techs: :projects).all.sort_by(&:name)
  end
end

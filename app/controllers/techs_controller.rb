class TechsController < ApplicationController
  def index
    @techs = Tech.includes(:tech_category, :projects).all.sort_by(&:name)
  end
end

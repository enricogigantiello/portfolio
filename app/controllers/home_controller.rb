class HomeController < ApplicationController
  def index
    @jobs = Job.includes(projects: :project_achievements).ordered
    @educations = Education.ordered
    @languages = Language.ordered
    @tech_categories = TechCategory.includes(:techs).all
  end
end

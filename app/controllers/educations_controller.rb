class EducationsController < ApplicationController
  def index
    @educations = Education.ordered
  end

  def show
    @education = Education.find(params[:id])
  end
end

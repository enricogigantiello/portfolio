class JobsController < ApplicationController
  def index
    @jobs = Job.includes(:projects).ordered
  end

  def show
    @job = Job.includes(projects: [ :techs, :project_achievements, :reference_links ]).find(params[:id])
  end
end

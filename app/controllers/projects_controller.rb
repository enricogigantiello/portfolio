class ProjectsController < ApplicationController
  def index
    if params[:job_id]
      @job = Job.find(params[:job_id])
      @projects = @job.projects.includes(:techs, :project_achievements, :reference_links).ordered
    else
      @projects = Project.includes(:job, :techs, :project_achievements, :reference_links).ordered
    end
  end

  def show
    @project = Project.includes(:job, :techs, :project_achievements, :reference_links).find(params[:id])
  end
end

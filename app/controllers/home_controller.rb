class HomeController < ApplicationController
  before_action :authenticate_user!, only: [ :cv_preview ]
  before_action :require_owner!, only: [ :cv_preview ]
  def index
    @jobs = Job.includes(projects: :project_achievements).ordered
    @educations = Education.ordered
    @languages = Language.ordered
    @tech_categories = TechCategory.includes(:techs).all
  end

  def cv
    @jobs = Job.includes(projects: [ :project_achievements, :techs ]).ordered
    @educations = Education.ordered
    @languages = Language.ordered
    @tech_categories = TechCategory.includes(:techs).all

    respond_to do |format|
      format.pdf do
        html = render_to_string(template: "home/cv", layout: "pdf", formats: [ :html ])
        pdf = Grover.new(html, format: "A4", print_background: true,
          margin: { top: "1cm", bottom: "1cm", left: "1.5cm", right: "1.5cm" }).to_pdf
        send_data pdf, filename: "#{@profile.full_name} cv.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def cv_preview
    @jobs = Job.includes(projects: [ :project_achievements, :techs ]).ordered
    @educations = Education.ordered
    @languages = Language.ordered
    @tech_categories = TechCategory.includes(:techs).all

    render template: "home/cv", layout: "pdf"
  end
end

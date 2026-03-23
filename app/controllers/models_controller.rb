class ModelsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_owner!

  def index
    @models = Model.all
  end

  def show
    @model = Model.find(params[:id])
  end

  def refresh
    Model.refresh!
    redirect_to models_path, notice: "Models refreshed successfully"
  end
end

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  before_action :set_locale
  before_action :set_profile

  private

  def set_profile
    @profile = Profile.instance
  end

  def set_locale
    locale = params[:locale]&.to_sym
    I18n.locale = if locale && I18n.available_locales.include?(locale)
      locale
    else
      I18n.default_locale
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end

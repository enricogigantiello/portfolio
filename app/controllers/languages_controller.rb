class LanguagesController < ApplicationController
  def index
    @languages = Language.ordered
  end
end

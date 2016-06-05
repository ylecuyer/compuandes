class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  after_action :verify_authorized, unless: :excepted_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def excepted_controller?
    is_a?(ActiveAdmin::BaseController) || is_a?(ActiveAdmin::Devise::SessionsController) 
  end

end

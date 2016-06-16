class StaticController < ActionController::Base
  layout 'application'

  def index
    if user_signed_in?
      redirect_to users_path
    else
      render layout: false
    end
  end

  def services
  end

end

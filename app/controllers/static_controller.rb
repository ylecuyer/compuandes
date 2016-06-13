class StaticController < ActionController::Base

  def index
    if user_signed_in?
      redirect_to users_path
    else
      render layout: false
    end
  end

end

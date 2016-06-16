class Users::SessionsController < Devise::SessionsController
  layout false

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      services_path
    else
      root_path
    end
  end

end

class Users::SessionsController < Devise::SessionsController
  layout false

      generated_password = Devise.friendly_token.first(8)  
end

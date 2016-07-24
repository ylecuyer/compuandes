class WizardController < ApplicationController
  include Wicked::Wizard

  steps :linkedin, :auth, :personal, :profesional

  def show
    linkedin_client_id=ENV['LINKEDIN_CLIENT_ID']
    linkedin_client_secret=ENV['LINKEDIN_CLIENT_SECRET']
    
    client = LinkedIn::Client.new(linkedin_client_id, linkedin_client_secret)

    case step
    when :linkedin
      request_token = client.request_token({:oauth_callback => "http://localhost:3000/wizard/auth"}, :scope => "r_basicprofile")
      
      session[:rtoken] = request_token.token
      session[:rsecret] = request_token.secret

      @linkedin_url = request_token.authorize_url
    when :auth
        session[:atoken], session[:asecret] = client.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
        skip_step
    when :personal
      @user = current_user
      if session[:atoken].present?
        client.authorize_from_access(session[:atoken], session[:asecret])
        @profile = client.profile(fields: [:first_name, :last_name, :picture_url, :public_profile_url])
      end
    when :profesional
      @user = current_user
      if session[:atoken].present?
        client.authorize_from_access(session[:atoken], session[:asecret])
        @profile = client.profile(fields: :positions)
      end
    end

    render_wizard
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    render_wizard @user
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :first_year, :facebook, :linkedin, :avatar, 
       :cv,
       personal_contacts_attributes: [:id, :address_1, :address_2, :address_3, :country, :state, :zip_code, :city, :extra, :phone, :mobile, :email],
       profesional_contacts_attributes: [:id, :address_1, :address_2, :address_3, :country, :state, :zip_code, :city, :extra, :phone, :mobile, :email, :company, :job, :company_website]
    )
  end
end

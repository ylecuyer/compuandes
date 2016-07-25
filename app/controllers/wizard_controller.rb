class WizardController < ApplicationController
  include Wicked::Wizard

  steps :linkedin, :auth, :personal, :profesional

  def show
    
    client = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_CLIENT_SECRET'])

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
        @profile = client.profile(fields: [:first_name, :last_name, :'picture-urls::(original)', :public_profile_url])
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

    if params[:use_linkedin_profile_picture]
      client = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_CLIENT_SECRET'])
      client.authorize_from_access(session[:atoken], session[:asecret])
      picture_url = client.picture_urls.all.first
      @user.avatar = URI.parse(picture_url).open
    end

    @user.update_attributes(user_params)
    render_wizard @user
  end

  private

  def finish_wizard_path
      user_path(current_user)
  end

  def user_params
    params.require(:user).permit(:last_name, :first_name, :first_year, :facebook, :linkedin, :avatar, 
       :cv,
       personal_contacts_attributes: [:id, :address_1, :address_2, :address_3, :country, :state, :zip_code, :city, :extra, :phone, :mobile, :email],
       profesional_contacts_attributes: [:id, :address_1, :address_2, :address_3, :country, :state, :zip_code, :city, :extra, :phone, :mobile, :email, :company, :job, :company_website]
    )
  end
end

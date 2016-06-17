class UsersController < ApplicationController
  include UsersHelper

  def index
    authorize User
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
    authorize @user
  end

  def country
    authorize User, :index?
    @region = params[:region]

    @personal_contacts = PersonalContact.where('country = ?', params[:region])
    @profesional_contacts = ProfesionalContact.where('country = ?', params[:region])

  end

  def map

    authorize User, :index?
    @region = params[:region]

    @is_worldmap = params[:region].nil?

    @map = case @region 
           when 'NA' 
             'north_america_mill'
           when 'SA'
             'south_america_mill'
           when 'EU'
             'europe_mill'
           when 'OC'
             'oceania_mill'
           when 'AS'
             'asia_mill'
           when 'AF'
             'africa_mill'
           when nil
             'continents_mill'
           end
  end

  def search
    authorize User, :index?

    @users = User.distinct.order('last_name asc, first_name asc').page(params[:page]).per(9)
    @users = @users.joins(:personal_contacts)
    @users = @users.joins(:profesional_contacts)

    if params[:last_name].present?
      term = params[:last_name]
      if params[:last_name_contains]
        term = "%#{term}%"
      end
      term = "lower(unaccent('#{term}'))"
      @users = @users.where("lower(unaccent(last_name)) LIKE #{term}")
    end

    if params[:first_name].present?
      term = params[:first_name]
      if params[:first_name_contains]
        term = "%#{term}%"
      end
      term = "lower(unaccent('#{term}'))"
      @users = @users.where("lower(unaccent(first_name)) LIKE #{term}")
    end

    if params[:graduate_year].present?
      @users = @users.where('graduate_year = ?', params[:graduate_year])
    end

    if params[:company].present?
      term = params[:company]
      if params[:company_contains]
        term = "%#{term}%"
      end
      term = "lower(unaccent('#{term}'))"
      @users = @users.where("lower(unaccent(company)) LIKE #{term}")
    end

    if params[:job].present?
      term = params[:job]
      if params[:job_contains]
        term = "%#{term}%"
      end
      term = "lower(unaccent('#{term}'))"
      @users = @users.where("lower(unaccent(job)) LIKE #{term}")
    end

    if params[:city].present?
      term = params[:city]
      if params[:city_contains]
        term = "%#{term}%"
      end
      term = "lower(unaccent('#{term}'))"
      @users = @users.where("lower(unaccent(personal_contacts.city)) LIKE #{term} or lower(unaccent(profesional_contacts.city)) LIKE #{term}")
    end

    if params[:country][0].present?
      term = params[:country][0]
      term = "lower(unaccent('#{term}'))"
      @users = @users.where("lower(unaccent(personal_contacts.country)) = #{term} or lower(unaccent(profesional_contacts.country)) = #{term}")
    end

  end

  def show
    @user = User.find params[:id]
    authorize @user
  end

  def vcard

    @user = User.find params[:id]
    authorize @user, :show?

    require 'vpim/vcard'

    card = Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.given = @user.first_name
        name.family = @user.last_name
      end

      maker.add_photo do |photo|
        photo.link = avatar_url(@user)
      end

      maker.add_email(@user.email) { |e| e.location = 'uniandes' }

      maker.add_url(facebook_url(@user))
      maker.add_url(linkedin_url(@user))

    end

    send_data card, filename: "#{@user.email}.vcf"

  end

  def update
    @user = User.find params[:id]
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: 'Actualizacion hecha'
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :graduate_year, :facebook, :linkedin, 
       personal_contacts_attributes: [:id, :address_1, :address_2, :address_3, :country, :state, :zip_code, :city, :extra, :phone, :mobile, :email],
       profesional_contacts_attributes: [:id, :address_1, :address_2, :address_3, :country, :state, :zip_code, :city, :extra, :phone, :mobile, :email, :company, :job, :company_website]
    )
  end

end

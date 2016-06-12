class UsersController < ApplicationController
  include UsersHelper

  def index
    authorize User
    @user = User.new
  end

  def map
    authorize User, :index?
    @region = params[:region]
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
           else
             'continents_mill'
           end
  end

  def search
    authorize User, :index?

    @users = User.order('last_name asc, first_name asc').page(params[:page]).per(9)

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

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:azureactivedirectory]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_attached_file :cv
  validates_attachment_content_type :cv, content_type: ["application/pdf","application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"]

  has_many :personal_contacts
  accepts_nested_attributes_for :personal_contacts

  has_many :profesional_contacts
  accepts_nested_attributes_for :profesional_contacts

  def full_name
    [last_name, first_name].join(" ")
  end

  after_create :init_contacts

  private

  def init_contacts
    self.personal_contacts = [PersonalContact.new, PersonalContact.new]
    self.profesional_contacts = [ProfesionalContact.new, ProfesionalContact.new]
  end

  def should_record_timestamps?
    (self.changes.keys.map(&:to_sym) - (Devise::Models::Trackable.required_fields(nil) + [:remember_token, :remember_created_at])).present? && super
  end

end

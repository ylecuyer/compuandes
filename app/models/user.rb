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

  has_many :personal_contacts, -> { order(id: :asc) }
  accepts_nested_attributes_for :personal_contacts

  has_many :profesional_contacts, -> { order(id: :asc) }
  accepts_nested_attributes_for :profesional_contacts

  def full_name
    [last_name, first_name].join(" ")
  end

  def completeness
    score = 0
    total = 0.0

    score += 15 if avatar.present? 
    total += 15

    score += 5 if last_name.present?
    total += 5

    score += 5 if first_name.present?
    total += 5

    score += 5 if first_year.present?
    total += 5

    if personal_contacts[0].email.present? || personal_contacts[1].email.present? || profesional_contacts[0].email.present? || profesional_contacts[1].email.present?
      score += 15
    end
    total += 15

    if personal_contacts[0].phone.present? || personal_contacts[1].phone.present? || profesional_contacts[0].phone.present? || profesional_contacts[1].phone.present? || personal_contacts[0].mobile.present? || personal_contacts[1].mobile.present? || profesional_contacts[0].mobile.present? || profesional_contacts[1].mobile.present?
      score += 15
    end
    total += 15

    if profesional_contacts[0].job.present? || profesional_contacts[1].job.present?
      score += 15
    end
    total += 15

    if profesional_contacts[0].company.present? || profesional_contacts[1].company.present?
      score += 15
    end
    total += 15
    
    score/total
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

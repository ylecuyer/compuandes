class PersonalContact < ActiveRecord::Base
  belongs_to :user
  
  def address
    [address_1, address_2, address_3, extra, zip_code, city, state, ISO3166::Country.new(country).try(:name)].reject(&:blank?).join("\n")
  end

end

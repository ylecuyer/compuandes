module UsersHelper

  include LetterAvatar::AvatarHelper

  def avatar_url(user)
    if user.avatar?
      user.avatar.url(:thumb)
    else
      letter_avatar_url(user.full_name, 100)
    end
  end

  def linkedin_url(user)
    "https://www.linkedin.com/in/#{user.linkedin}"
  end

  def linkedin_tag(user)
    if user.linkedin.present?
      link_to linkedin_url(user), target: '_blank' do
        image_tag 'logo_linkedin.png', size: '25x25'
      end
    else
      image_tag 'logo_linkedin.png', size: '25x25', class: 'disabled'
    end
  end

  def facebook_url(user)
    "https://www.facebook.com/#{user.facebook}"
  end

  def facebook_tag(user)
    if user.facebook.present?
      link_to facebook_url(user), target: '_blank' do
        image_tag 'logo_facebook.png', size: '25x25'
      end
    else
      image_tag 'logo_facebook.png', size: '25x25', class: 'disabled'
    end
  end

  def uniandes_tag(user)
    mail_to user.email do
      image_tag 'logo_uniandes.png', size: '25x25'
    end
  end

  def vcard_tag(user)
    link_to user_vcard_path(user), target: '_blank' do
      image_tag 'vcf.gif'
    end
  end

  def cv_tag(user)
    if user.cv.present?
      link_to user.cv.url, target: '_blank' do
        image_tag 'cv.gif'
      end
    else
        image_tag 'cv.gif', class: 'disabled'
    end
  end
end

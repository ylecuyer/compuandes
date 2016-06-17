ActiveAdmin.register User do
  permit_params :avatar, :last_name, :first_name, :first_year, :facebook, :linkedin, :cv, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "User details" do
      f.input :avatar
      f.input :last_name
      f.input :first_name
      f.input :first_year
      f.input :facebook
      f.input :linkedin
      f.input :cv
    end
    f.actions
  end

  show do
    attributes_table do
      row :avatar do
        image_tag avatar_url(user)
      end
      row :last_name
      row :first_name
      row :first_year
      row :facebook do
        link_to user.facebook, facebook_url(user)
      end
      row :linkedin do
        link_to user.linkedin, linkedin_url(user)
      end
    end
  end

end

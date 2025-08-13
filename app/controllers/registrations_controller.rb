class RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      resource.update_without_password(params)
    else
      super
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def after_sign_up_path_for(resource)
    home_index_path
  end
end

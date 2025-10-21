class RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      # パスワード変更時は Devise 既定のフロー（current_password 必須）
      resource.update_with_password(params)
    else
      # 画像/名前/メールだけの更新は current_password なしでOK
      params = params.except(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def after_sign_up_path_for(resource)
    home_index_path
  end
end

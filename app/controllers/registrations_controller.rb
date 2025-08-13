class RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      # パスワードを変更する場合は current_password を必須にして Devise 標準を使う
      # ※ここでは current_password を消さないこと！
      resource.update_with_password(params)
    else
      # パスワード変更なしの場合は current_password を捨てて独自メソッドで更新
      params.delete(:current_password)
      resource.update_without_current_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def after_sign_up_path_for(resource)
    home_index_path
  end
end

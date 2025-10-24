class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_last_active_time,
                if: :user_signed_in?,
                unless: :logging_out?
  before_action :mark_logged_out, if: :logging_out?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: [ :name, :gender, :profile_image ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :email, :profile_image ])
  end

  private

  # ログイン中はlast_active_atを更新
  def update_last_active_time
    current_user.update_column(:last_active_at, Time.current)
  end

  # ログアウト判定
  def logging_out?
    devise_controller? && controller_name == "sessions" && action_name == "destroy"
  end

  # ログアウト時にlast_active_atをnilに
  def mark_logged_out
    current_user&.update_column(:last_active_at, nil)
  end
end

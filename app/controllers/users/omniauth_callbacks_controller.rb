module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth = request.env["omniauth.auth"]
      unless auth
        redirect_to new_user_session_path, alert: "Google からの認証情報が取得できませんでした。"
        return
      end

      @user = User.from_omniauth(auth)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        # まれにバリデーションで落ちた場合
        session["devise.google_data"] = auth.except("extra")
        redirect_to new_user_registration_url, alert: "Google ログインに失敗しました。"
      end
    end

    def failure
      redirect_to root_path, alert: "Google ログインがキャンセルまたは失敗しました。"
    end
  end
end

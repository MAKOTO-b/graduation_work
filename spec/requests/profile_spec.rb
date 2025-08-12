require "rails_helper"

# path→ok
RSpec.describe "Profile (Devise registrations)", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, password: "password") }

  describe "GET /users/edit (edit_user_registration_path)" do
    it "未ログインはログイン画面へリダイレクト" do
      get edit_user_registration_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to new_user_session_path
    end

    it "ログイン済みは200で表示" do
      sign_in user
      get edit_user_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT/PATCH /users (user_registration_path)" do
    context "ログイン済み" do
      before { sign_in user }

      it "パスワード系が空なら、現在のパスワードなしで名前だけ更新できる" do
        params = {
          user: {
            name: "Changed Name",
            password: "",
            password_confirmation: "",
            current_password: "" # Devise標準は必須だが、あなたのアプリは空時スキップする実装
          }
        }
        put user_registration_path, params: params

        expect(response).to have_http_status(:found) # 成功後にリダイレクト想定
        expect(follow_redirect!).to be true
        expect(user.reload.name).to eq("Changed Name")
      end

      it "パスワードを変更する場合は current_password が正しければ更新成功" do
        params = {
          user: {
            name: user.name,
            password: "newpassword",
            password_confirmation: "newpassword",
            current_password: "password"
          }
        }
        put user_registration_path, params: params

        expect(response).to have_http_status(:found)
        expect(follow_redirect!).to be true

        # 新パスワードでログインできるか確認
        sign_out user
        post user_session_path, params: { user: { email: user.email, password: "newpassword" } }
        expect(response).to have_http_status(:found)
      end

      it "current_password が不正ならパスワード更新は失敗してエラー表示" do
        params = {
          user: {
            password: "newpassword",
            password_confirmation: "newpassword",
            current_password: "wrong"
          }
        }
        put user_registration_path, params: params

        # Deviseは再描画(200)または422を返す実装パターンあり
        expect(response.status).to satisfy { |s| [200, 422].include?(s) }
        expect(response.body).to include("現在のパスワード").or include("Current password")
        expect(user.reload.valid_password?("newpassword")).to be false
      end

      it "プロフィール画像をアップロードできる（CarrierWave想定・任意）" do
        file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/avatar.png"), "image/png")
        params = {
          user: {
            profile_image: file,
            current_password: "" # あなたの実装では空でOK
          }
        }
        patch user_registration_path, params: params

        expect(response).to have_http_status(:found)
        expect(user.reload.profile_image?).to be true
      end
    end

    it "未ログインは更新できずログイン画面へ" do
      put user_registration_path, params: { user: { name: "X" } }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
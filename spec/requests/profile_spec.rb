require "rails_helper"

RSpec.describe "Profile (Devise registrations)", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, password: "password") }

  describe "GET /users/edit (edit_user_registration_path)" do
    it "未ログインはログイン画面へリダイレクト" do
      get edit_user_registration_path
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

      it "現在のパスワードなしで名前だけ更新できる" do
        params = { user: { name: "Changed Name" } }

        put user_registration_path, params: params

        # 302(:found) or 303(:see_other) のどちらでも許容
        expect(response.status).to satisfy { |s| [302, 303].include?(s) }
        expect(user.reload.name).to eq("Changed Name")
      end

      it "現在のパスワードなしでメールだけ更新できる" do
        params = { user: { email: "changed@example.com" } }

        patch user_registration_path, params: params

        expect(response.status).to satisfy { |s| [302, 303].include?(s) }
        expect(user.reload.email).to eq("changed@example.com")
      end

      it "プロフィール画像をアップロードできる" do
        file = Rack::Test::UploadedFile.new(
          Rails.root.join("spec/fixtures/files/avatar.png"),
          "image/png"
        )

        params = { user: { profile_image: file } }

        patch user_registration_path, params: params

        expect(response.status).to satisfy { |s| [302, 303].include?(s) }
        expect(user.reload.profile_image?).to be true
      end

      it "パスワードを送っても無視（変更されない）される" do
        old_encrypted_password = user.encrypted_password.dup

        params = {
          user: {
            name: "Keeps Name",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        put user_registration_path, params: params

        expect(response.status).to satisfy { |s| [302, 303].include?(s) }
        expect(user.reload.encrypted_password).to eq(old_encrypted_password)
      end
    end

    it "未ログインは更新できずログイン画面へ" do
      put user_registration_path, params: { user: { name: "X" } }
      expect(response).to redirect_to new_user_session_path
    end
  end
end

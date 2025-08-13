require "rails_helper"

RSpec.describe "RmdChatRooms", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user)  { create(:user) }
  let(:other) { create(:user) }
  let(:room)  { create(:rmd_chat_room) }

  before do
    # 参加者に2人入れておく（コントローラで相手ユーザー参照しているため）
    room.rmd_chat_room_users.create!(user: user)
    room.rmd_chat_room_users.create!(user: other)
  end

  describe "GET /rmd_chat_rooms/:id (rmd_chat_room_path)" do
    context "未ログイン" do
      it "ログイン画面へリダイレクト(HTML想定)" do
        get rmd_chat_room_path(room), headers: { "ACCEPT" => "text/html" }
        expect(response.status).to be_between(300, 399)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログイン済み" do
      it "200 or リダイレクト後に200で表示できる" do
        sign_in user
        get rmd_chat_room_path(room), headers: { "ACCEPT" => "text/html" }

        # Turbo/リダイレクトを許容
        if [302, 303].include?(response.status)
          follow_redirect!
        end

        expect(response).to have_http_status(:ok)
        # ビューの固有要素（textarea の placeholder など）で確認
        expect(response.body).to include("メッセージを入力").or include("chat-message-textarea")
      end
    end
  end
end

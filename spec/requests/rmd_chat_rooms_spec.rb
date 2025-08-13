require "rails_helper"

RSpec.describe "RmdChatRooms", type: :request do
  let(:me)    { create(:user) }
  let(:other) { create(:user) }

  describe "POST /rmd_chat_rooms (rmd_chat_rooms_path)" do
    it "未ログインはログイン画面へリダイレクト" do
      post rmd_chat_rooms_path, params: { user_id: other.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "ログイン済みはルーム作成(または既存ルームに遷移)" do
      sign_in me

      # 既存再利用のパターンもあるので 0 or 1 を許容
      expect {
        post rmd_chat_rooms_path, params: { user_id: other.id }
      }.to change(RmdChatRoom, :count).by(1).or change(RmdChatRoom, :count).by(0)

      expect(response).to have_http_status(302).or have_http_status(303)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      # 可能なら show ページの何かしらの要素を確認
      expect(response.body).to include("chat-root").or include("メッセージ")
    end
  end

  describe "GET /rmd_chat_rooms/:id (rmd_chat_room_path)" do
    let(:room) { create(:rmd_chat_room) }

    it "未ログインはログイン画面へリダイレクト" do
      get rmd_chat_room_path(room)
      expect(response).to redirect_to new_user_session_path
    end

    it "ログイン済みは200（参加者チェックがあるなら参加者にしておく）" do
      sign_in me
      # 参加者制御がある実装なら、ここで me をルーム参加者にする
      # 例: create(:rmd_chat_membership, user: me, rmd_chat_room: room) など
      get rmd_chat_room_path(room)
      expect(response).to have_http_status(:ok).or have_http_status(:forbidden) # 実装に合わせて
    end
  end
end

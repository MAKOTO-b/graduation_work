require "rails_helper"

# path→ok
RSpec.describe "RmdChatMessages", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:member) { create(:user) }
  let(:non_member) { create(:user) }
  let(:room) { create(:rmd_chat_room, users: [ member ]) }

  it "未ログインはNG" do
    post rmd_chat_rooms_path(room), params: { rmd_chat_message: { content: "hi" } }, headers: { "ACCEPT" => "text/html" }
    expect(response).to redirect_to new_user_session_path
  end

  it "参加者は投稿OK" do
    sign_in member
    expect {
      post rmd_chat_rooms_path(room), params: { rmd_chat_message: { content: "hi" } }, headers: { "ACCEPT" => "text/html" }
    }.to change(RmdChatMessage, :count).by(1)
  end

  it "非参加者は投稿NG" do
    sign_in non_member
    post rmd_chat_rooms_path(room), params: { rmd_chat_message: { content: "x" } }
    expect(response.status).to satisfy { |s| [ 302, 403, 404 ].include?(s) }
  end
end

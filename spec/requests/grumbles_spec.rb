require "rails_helper"

# path→ok
RSpec.describe "Grumbles", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:owner) { create(:user) }
  let(:other) { create(:user) }
  let!(:grumble) { create(:grumble, user: owner, content: "old") }

  it "未ログインは作成NG" do
    post grumbles_path, params: { grumble: { content: "x" } }
    expect(response).to redirect_to new_user_session_path
  end

  it "ログイン済みは作成OK" do
    sign_in owner
    expect {
      post grumbles_path, params: { grumble: { content: "x" } }
    }.to change(Grumble, :count).by(1)
  end

  it "他人の投稿は更新できない" do
    sign_in other
    patch grumble_path(grumble), params: { grumble: { content: "hack" } }
    expect(response.status).to satisfy { |s| [302, 403].include?(s) }
    expect(grumble.reload.content).to eq("old")
  end

  it "オーナーは削除できる" do
    sign_in owner
    expect { delete grumble_path(grumble) }.to change(Grumble, :count).by(-1)
  end
end
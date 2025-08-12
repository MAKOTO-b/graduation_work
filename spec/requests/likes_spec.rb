require "rails_helper"

# path→ok
RSpec.describe "Likes", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user) }
  let(:grumble) { create(:grumble) }

  it "未ログインはNG" do
    post grumble_likes_path(grumble)
    expect(response).to redirect_to new_user_session_path
  end

  it "ログイン済みは一度だけいいねできる" do
    sign_in user
    post grumble_likes_path(grumble)
    expect { post grumble_likes_path(grumble) }.not_to change(Like, :count)
  end

  it "解除できる" do
    sign_in user
    post grumble_likes_path(grumble)
    delete grumble_like_path(grumble, Like.last)
    expect(Like.where(user:, grumble:)).to be_empty
  end
end
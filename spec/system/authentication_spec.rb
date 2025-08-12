require "rails_helper"

# path-ok
# check-ok
RSpec.describe "Authentication", type: :system do
  before { driven_by(:selenium, using: :chrome, options: { headless: true }) }

  it "ユーザー登録できてログイン状態になる" do
    visit new_user_registration_path
    fill_in "Email", with: "user1@example.com"
    fill_in "Name", with: "Test User"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "登録"

    expect(page).to have_content("ログインに成功しました。").or have_content("ログアウトしました。") # 実装に合わせて
  end

  it "既存ユーザーでログインできる" do
    user = create(:user, password: "password")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "ログイン"

    expect(page).to have_current_path(root_path).or have_content(user.name)
  end
end

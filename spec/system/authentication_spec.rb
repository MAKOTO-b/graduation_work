require "rails_helper"

# path-ok
# check-ok
RSpec.describe "Authentication", type: :system do
  it "ユーザー登録できてログイン状態になる" do
    visit new_user_registration_path
    fill_in "メールアドレス", with: "user1@example.com"
    fill_in "ユーザーネーム", with: "Test User"
    fill_in "パスワード", with: "password"
    fill_in "パスワード確認", with: "password"
    click_button "登録"

    expect(page).to have_content("アカウント登録が完了しました。")
  end

  it "既存ユーザーでログインできる" do
    user = create(:user, password: "password")

    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_current_path(root_path).or have_content("ログインに成功しました。")
  end
end

require "rails_helper"

# path→ok
# check-ok
RSpec.describe "プロフィール編集", type: :system do

  let(:user) { create(:user, password: "password") }

  it "ユーザー詳細から編集画面へ遷移して、名前を変更できる" do
    login_as(user, scope: :user)

    # まず users#show を開く
    visit user_path(user)

    # 編集リンクをクリック（data-test 推奨。無ければテキストで）
    find("[data-test='profile-edit-link']").click
    # もしくは click_link "プロフィールを編集"

    # 編集フォームで更新
    fill_in "Name", with: "Changed Name"
    fill_in "Email", with: "changed@example.com"   # ← メールも入力
    fill_in "Password", with: ""               # 空の更新を許可する実装
    fill_in "Password confirmation", with: ""
    fill_in "Current password", with: ""       # あなたの実装では空でOK
    click_button "更新する"                      # ボタン文言に合わせて

    # root に戻ってフラッシュ or 表示確認（あなたの実装に合わせて）
    expect(page).to have_content("アカウント情報を変更しました").or have_content("Changed Name")
  end

  it "他人のユーザー詳細では編集リンクが出ない" do
    login_as(user, scope: :user)
    other = create(:user)
    visit user_path(other)

    expect(page).not_to have_selector("[data-test='profile-edit-link']")
    # もしくは expect(page).not_to have_link("プロフィールを編集")
  end
end

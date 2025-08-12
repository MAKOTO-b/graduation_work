require "rails_helper"

# path-ok
# check-ok
RSpec.describe "Grumbles", type: :system do
  before { driven_by(:selenium, using: :chrome, options: { headless: true }) }

  it "ログイン→投稿作成→一覧で表示→いいね→取り消し" do
    user = create(:user, password: "password")
    login_as(user, scope: :user) # Devise Warden helper（rails_helperで有効化してる前提）

    visit new_grumble_path
    fill_in "Content", with: "これはテスト投稿です"
    click_button "投稿する"

    expect(page).to have_text("これはテスト投稿です")

    # data-test属性の利用を推奨（安定化）
    find("[data-test='like-button']").click
    expect(page).to have_text("いいね 1").or have_selector("[data-test='like-count']", text: "1")

    find("[data-test='like-button']").click
    expect(page).to have_text("いいね 0").or have_selector("[data-test='like-count']", text: "0")
  end
end

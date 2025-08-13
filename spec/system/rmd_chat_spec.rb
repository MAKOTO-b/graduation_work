require "rails_helper"

# path-ok
# check-ok
RSpec.describe "Rmd Chat", type: :system do
  it "ルーム入室→メッセージ送信→履歴に表示→再読込でも残る" do
    user = create(:user, password: "password")
    room = create(:rmd_chat_room, users: [ user ])  # factoryのafter(:create)で参加させる
    login_as(user, scope: :user)

    visit rmd_chat_rooms_path(room)                 # ルートは実装に合わせる
    fill_in "chat-message-textarea", with: "こんにちは"
    click_button "送信"

    expect(page).to have_text("こんにちは")

    visit current_path
    expect(page).to have_text("こんにちは")
  end
end

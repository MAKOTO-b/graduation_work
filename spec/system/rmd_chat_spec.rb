require "rails_helper"

RSpec.describe "Rmd Chat", type: :system do
  let(:user)  { create(:user) }
  let(:other) { create(:user) }
  let(:room)  { create(:rmd_chat_room) }

  before do
    # ルームに自分と相手の2人を参加させる（実装の関連名に合わせて調整）
    room.rmd_chat_room_users.create!(user: user)
    room.rmd_chat_room_users.create!(user: other)
  end

  it "ルーム入室→メッセージ送信→履歴に表示→再読込でも残る" do
    login_as(user, scope: :user)

    visit rmd_chat_room_path(room)

    # 入力欄（placeholder指定が確実）
    find("textarea[placeholder='メッセージを入力']").set("こんにちは")
    click_button "送信"

    expect(page).to have_text("こんにちは")

    # 再読込しても残っていること
    visit current_path
    expect(page).to have_text("こんにちは")
  end
end

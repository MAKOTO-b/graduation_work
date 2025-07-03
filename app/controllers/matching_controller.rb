class MatchingController < ApplicationController

  before_action :authenticate_user!

  def index
    # テストしたいためここで他ユーザーのマッチングステータスを意図的に更新
    # テスト用コード(自分以外の全ユーザーのステータスを1へ更新)
    test_user = User.where("id >= ?", 2)
    test_user.update(matching_status: 1)
    # テスト用コード(自分以外の全ユーザーのステータスを0へ更新)
    # test_user = User.where("id >= ?", 2)
    # test_user.update(matching_status: 0)

    # マッチングステータス更新
    # →退出時にマッチングステータスを削除
    # ログインユーザーのレコード取得
    user = User.find(current_user.id)
    user.update(matching_status: 1)

    # マッチングステータスが空白ではない他のユーザーレコード取得
    @match_users = User.where(matching_status: 1).where.not(id: current_user.id)
  end
end

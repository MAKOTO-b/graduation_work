class MatchingController < ApplicationController
  before_action :authenticate_user!

  def index
    # マッチングステータス更新
    # →退出時にマッチングステータスを削除
    # ログインユーザーのレコード取得
    user = User.find(current_user.id)
    user.update(matching_status: :matched)

    # マッチングステータスが空白ではない他のユーザーレコード取得
    @match_users = User.where.not(id: current_user.id)

    # 相手→自分宛の未読メッセージ数を user_id ごとに集計
    counts = RmdChatMessage
            .where(partner_id: current_user.id, is_read: false, user_id: @match_users.select(:id))
            .group(:user_id)
            .count

    # 参照しやすいようにHashで持たせる
    @unread_counts_by_user_id = counts
  end
end

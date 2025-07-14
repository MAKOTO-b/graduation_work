class SessionsController < Devise::SessionsController
  def create
    # 前日データ削除処理（ログイン前に実行される）
    cleanup_old_data
    # Deviseの通常のログイン処理を実行
    super
  end

  protected

  def after_sign_in_path_for(resource)
    home_index_path
  end

  # 前日のデータを全削除
  def cleanup_old_data
    # レコードがあった場合のみ処理を実行した方がいいか?
    # 個人チャット
    ChatRoomUser.where("created_at < ?", Date.today).destroy_all
    ChatMessage.where("created_at < ?", Date.today).destroy_all
    ChatRoom.where("created_at < ?", Date.today).destroy_all
    # ランダムチャット
    RmdChatRoomUser.where("created_at < ?", Date.today).destroy_all
    RmdChatMessage.where("created_at < ?", Date.today).destroy_all
    RmdChatRoom.where("created_at < ?", Date.today).destroy_all
  end
end

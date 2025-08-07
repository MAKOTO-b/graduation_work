class RmdChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    # 中間テーブルであるrmd_chat_room_usersテーブルから、user_idが
    # 自分のレコードを取得
    rmd_current_user_chat_rooms = RmdChatRoomUser.where(user_id: current_user.id).map(&:rmd_chat_room)
    # 自分がいるチャットルームでかつ、
    # マッチング一覧ページからクリックしたユーザーがいるチャットルームを取得
    rmd_chat_room = RmdChatRoomUser.where(rmd_chat_room: rmd_current_user_chat_rooms, user_id: params[:user_id])
                    .map(&:rmd_chat_room).first
    # チャットがなければ
    if rmd_chat_room.blank?
      # チャットルームを作成する
      rmd_chat_room = RmdChatRoom.create
      # 自分
      RmdChatRoomUser.create(rmd_chat_room: rmd_chat_room, user_id: current_user.id)
      # 相手
      RmdChatRoomUser.create(rmd_chat_room: rmd_chat_room, user_id: params[:user_id])
    end
    redirect_to action: :show, id: rmd_chat_room.id
  end

  def show
    # 相手と自分がいるチャットルーム取得
    @rmd_chat_room = RmdChatRoom.find(params[:id])
    # 相手の情報を取得
    @rmd_chat_room_user = @rmd_chat_room.rmd_chat_room_users.where.not(user_id: current_user.id).first.user
    # チャットメッセージ取得
    @rmd_chat_messages = RmdChatMessage.where(rmd_chat_room: @rmd_chat_room)
    @partner = @rmd_chat_room.users.where.not(id: current_user.id).first
  end
end

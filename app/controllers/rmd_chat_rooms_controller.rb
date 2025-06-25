class RmdChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    #参考元
    current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: params[:user_id]).map(&:chat_room).first
    ChatRoomUser.where(chat_room: 1, user_id: 1).map(&:chat_room).first
    if chat_room.blank?
      chat_room = ChatRoom.create
      ChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
      ChatRoomUser.create(chat_room: chat_room, user_id: params[:user_id])
    end
    redirect_to action: :show, id: chat_room.id

    #中間テーブルであるrmd_chat_room_usersテーブルから、user_idが
    #自分のレコードを取得
    rmd_current_user_chat_rooms = RmdChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    #自分がいるチャットルームでかつ、
    #マッチング一覧ページからクリックしたユーザーがいるチャットルームを取得
    rmd_chat_room = RmdChatRoomUser.where(chat_room: rmd_current_user_chat_rooms, user_id: params[:user_id])
                    .map(&:chat_room).first
    #チャットがなければ
    if rmd_chat_room.blank?
      #チャットルームを作成する
      rmd_chat_room = RmdChatRoom.create
      RmdChatRoomUser.create(chat_room: rmd_chat_room, user_id: current_user.id)
      RmdChatRoomUser.create(chat_room: rmd_chat_room, user_id: params[:user_id])
    end
    redirect_to action: :show, id: rmd_chat_room.id
  end
  
  def show
    @rmd_chat_room = RmdChatRoom.find(params[:id])
    @rmd_chat_room_user = @rmd_chat_room.rmd_chat_room_users.where.not(user_id: current_user.id).first.user
    @rmd_chat_messages = RmdChatMessage.where(rmd_chat_room: @rmd_chat_room)
  end
end

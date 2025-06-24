class RmdChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    #中間テーブルであるrmd_chat_room_usersテーブルから、user_idが
    #自分のレコードを取得
    current_user_chat_rooms = RmdChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    #自分がいるチャットルームでかつ、
    #マッチング一覧ページからクリックしたユーザーがいるチャットルームを取得
    rmd_chat_room = RmdChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: params[:user_id]).map(&:chat_room).first

    #チャットがなければ
    if rmd_chat_room.blank?
      rmd_chat_room = RmdChatRoom.create
      RmdChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
      RmdChatRoomUser.create(chat_room: chat_room, user_id: params[:user_id])
    end
    redirect_to action: :show, id: rmd_chat_room.id
  end
  
    def show
    end
end

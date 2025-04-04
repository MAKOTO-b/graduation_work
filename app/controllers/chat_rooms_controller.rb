class ChatRoomsController < ApplicationController
    before_action :authenticate_user!

  def index
  end

  def create
    #chat_room_usersから使用ユーザーのidを元にレコード取得
    #取得カラム:user_id,chat_room_id,chat_room_users_id
    #current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)

    #chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: params[:user_id]).map(&:chat_room).first
    #if chat_room.blank?
      #chat_room = ChatRoom.create
      #ChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
      #ChatRoomUser.create(chat_room: chat_room, user_id: params[:user_id])
    #end

    #使用ユーザーのレコードが取得されない場合。
    #if current_user_chat_rooms.blank?
        #chat_roomsに新規レコード作成
        #chat_room = ChatRoom.create
        #chat_room_usersに新規レコード作成
        #ChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
      #end
    #showへ遷移
    redirect_to action: :show
  end

  def show
  end
end

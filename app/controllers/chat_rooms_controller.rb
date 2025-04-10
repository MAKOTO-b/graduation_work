class ChatRoomsController < ApplicationController
    before_action :authenticate_user!

  def index
  end

  def create
    #chat_room_usersから使用ユーザーのidを元にレコード取得
    #取得カラム:user_id,chat_room_id,chat_room_users_id
    current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    #使用ユーザーのチャットルームid取得
    chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: current_user.id).map(&:chat_room).first

    #使用ユーザーのレコードが取得されない場合。
    if current_user_chat_rooms.blank?
        #chat_roomsに新規レコード作成
        chat_room = ChatRoom.create
        #chat_room_usersに新規レコード作成
        ChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
      end

    #show Actionへ遷移
    redirect_to action: :show, id: chat_room.id
  end

  def show
    #送られたパラメータ(id)を元にレコードを取得
    @chat_room = ChatRoom.find(params[:id])
    @User_name = User.find(params[:id])
    @chat_messages = ChatMessage.where(chat_room: @chat_room)
  end
end

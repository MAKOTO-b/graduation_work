class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    # chat_room_channel.rbとchat_room_channel.jsでデータ送受信できるようにする
    stream_from "chat_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # 送られてきたデータを元にレコードを作成
    ChatMessage.create!(
      content: data['chat_message'],
      user_id: current_user.id,
      chat_room_id: data['chat_room_id']
    )
  end
end

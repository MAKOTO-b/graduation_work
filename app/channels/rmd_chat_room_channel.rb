class RmdChatRoomChannel < ApplicationCable::Channel
  def subscribed
    # rmd_chat_room_channel.rbとrmd_chat_room_channel.jsでデータ送受信できるようにする
    stream_from "rmd_chat_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # 送られてきたデータを元にレコードを作成
    RmdChatMessage.create!(
      content: data["rmd_chat_message"],
      user_id: current_user.id,
      rmd_chat_room_id: data["rmd_chat_room_id"]
    )
  end
end

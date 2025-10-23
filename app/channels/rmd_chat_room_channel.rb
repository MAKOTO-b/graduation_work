class RmdChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rmd_chat_room_#{params[:room_id]}"
  end

  def speak(data)
    room = RmdChatRoom.find(data["chat_room_id"])
    partner = room.users.where.not(id: current_user.id).first

    message = RmdChatMessage.create!(
      content:      data["chat_message"],
      user_id:      current_user.id,
      rmd_chat_room_id: data["chat_room_id"],
      partner_id: partner&.id,
      is_read: false
    )

    mine_html = ApplicationController.renderer.render(
      partial: "rmd_chat_messages/rmd_chat_message",
      locals:  { rmd_chat_message: message, viewer_id: current_user.id } # 送信者視点
    )

    theirs_html = ApplicationController.renderer.render(
      partial: "rmd_chat_messages/rmd_chat_message",
      locals:  { rmd_chat_message: message, viewer_id: partner&.id } # 相手視点（必ず左）
    )

    ActionCable.server.broadcast(
      "rmd_chat_room_#{data["chat_room_id"]}",
      {
        sender_id:  message.user_id,
        mine_html:  mine_html,
        theirs_html: theirs_html
      }
    )
  end
end

class RmdChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rmd_chat_room_#{params[:room_id]}"
  end

  def speak(data)
    message = RmdChatMessage.create!(
      content: data["chat_message"],
      user_id: current_user.id,
      rmd_chat_room_id: data["chat_room_id"]
    )

    ActionCable.server.broadcast("rmd_chat_room_#{data["chat_room_id"]}", {
      chat_message_html: ApplicationController.renderer.render(
        partial: "rmd_chat_messages/rmd_chat_message",
        locals: { rmd_chat_message: message, viewer_id: current_user.id }
      )
    })
  end
end
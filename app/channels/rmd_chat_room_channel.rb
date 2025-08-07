class RmdChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rmd_chat_room_#{params[:room_id]}"
  end

  def speak(data)
    message = RmdChatMessage.create!(
      content: data["chat_message"],
      user_id: current_user.id,
      rmd_chat_room_id: data["chat_room_id"],
      partner_id: data["partner_id"]
    )

    ActionCable.server.broadcast "rmd_chat_room_#{data["chat_room_id"]}", {
      chat_message: ApplicationController.render(
        partial: "rmd_chat_messages/message",
        locals: { rmd_chat_message: message, current_user: current_user }
      )
    }
  end
end

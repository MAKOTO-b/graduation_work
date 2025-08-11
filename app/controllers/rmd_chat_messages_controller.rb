class RmdChatMessagesController < ApplicationController
  def create
    message = RmdChatMessage.create!(
      content: params[:content],
      user_id: current_user.id,
      rmd_chat_room_id: params[:rmd_chat_room_id],
      partner_id: params[:partner_id] # ここが重要
    )

    # メッセージを相手にもブロードキャスト
    ActionCable.server.broadcast "rmd_chat_room_#{params[:rmd_chat_room_id]}", {
      chat_message: ApplicationController.render(
        partial: "rmd_chat_messages/message",
        locals: { rmd_chat_message: message, current_user: current_user }
      )
    }
    head :ok
  end
end

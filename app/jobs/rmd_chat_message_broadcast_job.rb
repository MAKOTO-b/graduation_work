class RmdChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_message)
    #receivedへデータを渡す
    ActionCable.server.broadcast 'rmd_chat_room_channel', { rmd_chat_message: render_rmd_chat_message(rmd_chat_message) }
  end

  private

    def render_rmd_chat_message(rmd_chat_message)
      #コントローラーの制約を受けずに、任意のビューテンプレートをレンダリングする
      ApplicationController.renderer.render(partial: 'rmd_chat_messages/rmd_chat_message', locals: { rmd_chat_message: rmd_chat_message, current_user: rmd_chat_message.user })
    end
end

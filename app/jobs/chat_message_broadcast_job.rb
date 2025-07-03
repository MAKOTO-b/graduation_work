class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_message)
    # receivedへデータを渡す
    ActionCable.server.broadcast 'chat_room_channel', { chat_message: render_chat_message(chat_message) }
  end

  private

    def render_chat_message(chat_message)
      # コントローラーの制約を受けずに、任意のビューテンプレートをレンダリングする
      ApplicationController.renderer.render(partial: 'chat_messages/chat_message', locals: { chat_message: chat_message, current_user: chat_message.user })
    end
end


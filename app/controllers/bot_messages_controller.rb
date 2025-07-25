class BotMessagesController < ApplicationController
  def create # （1）
    return redirect_to bot_messages_path if params[:message].to_s.strip.blank?

    # セッション初期化（なければ空の配列に）
    messages = session[:messages] ||= []

    # ユーザーのメッセージを追加
    messages << { "content" => params[:message], "role" => "user" }

    # チャットボットの応答を取得
    assistant_response = ChatgptService.generate_response(messages)

    # 応答を追加
    messages << { "content" => assistant_response, "role" => "assistant" }

    # セッションには最新10件だけ保持（クッキー容量対策）
    session[:messages] = messages.last(10)

    redirect_to bot_messages_path
  end

  def index # （2）
    @messages = session[:messages] || []
    # p '@messages: ' + @messages.to_s
  end

  def clear_session # （3）
    session.delete(:messages)
    redirect_to root_path
  end
end

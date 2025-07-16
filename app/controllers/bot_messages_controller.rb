class BotMessagesController < ApplicationController
  def create # （1）
    unless params[:message].empty?
      messages = session[:messages] || []

      # ユーザーのメッセージを表示する
      messages << { "content" => params[:message], "role" => "user" }

      # エコーチャットボット
      assistant_response = params[:message]

      messages << { "content" => assistant_response, "role" => "assistant" }
      session[:messages] = messages
    end

    # p '@messages: ' + messages.to_s
    # p 'session[:messages]' + session[:messages].to_s
    redirect_to bot_messages_path  # create アクション後に index へリダイレクト
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

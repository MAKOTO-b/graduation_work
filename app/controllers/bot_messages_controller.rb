class BotMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :enforce_chatbot_daily_limit!, only: [ :create ]

  # セッションに保存する最大件数・最大文字数をかなり小さくする
  MAX_HISTORY = 6          # 10 -> 6 に圧縮
  MAX_CHARS   = 400        # 1メッセージの最大保存文字数

  def create
    return redirect_to bot_messages_path if params[:message].to_s.strip.blank?

    msgs = Array(session[:messages])

    # ユーザー入力を追加（保存時は文字数をクリップ）
    user_msg = { "role" => "user", "content" => params[:message].to_s }
    msgs << clip(user_msg)

    # 直近だけで API へ投げる（必要ならここでもトークン節約のためクリップ）
    history_for_api = msgs.last(MAX_HISTORY)

    assistant_response = ChatgptService.generate_response(history_for_api)

    # 応答を追加（保存はクリップ）
    msgs << clip({ "role" => "assistant", "content" => assistant_response.to_s })

    # セッションには最後の MAX_HISTORY 件だけ保存（さらに全件クリップ済み）
    msgs = msgs.last(MAX_HISTORY)

    begin
      session[:messages] = msgs
    rescue ActionDispatch::Cookies::CookieOverflow
      # 万一まだ大きい場合はさらに圧縮 or 履歴を最小化
      session[:messages] = msgs.last(2).map { |m| clip(m, max_chars: 200) }
    end

    current_user.incr_chatbot_message_count!
    redirect_to bot_messages_path
  end

  def index
    @messages = Array(session[:messages])
  end

  def clear_session
    session.delete(:messages)
    redirect_to root_path
  end

  private

  def clip(message, max_chars: MAX_CHARS)
    message.merge("content" => message["content"].to_s.mb_chars.limit(max_chars).to_s)
  end

  def enforce_chatbot_daily_limit!
    current_user.reset_chatbot_counter_if_new_day!
    unless current_user.can_send_chatbot_message?
      redirect_to bot_messages_path,
        alert: "本日のチャットボット利用上限（#{User::CHATBOT_DAILY_LIMIT}件）に達しました。明日またご利用ください。"
    end
  end
end

require "openai"

class ChatgptService
  def self.generate_response(messages)
    # if Rails.env.development?
    # last_message = messages.last
    # return "【モック応答】あなたは「#{last_message&.dig('content')}」と言いました。"
    # end
    # 1) ENV を最優先、なければ credentials(:openai, :api_key)
    api_key = ENV["OPENAI_API_KEY"].presence ||
              ENV["OPENAI_ACCESS_TOKEN"].presence || # どちらでもOK
              Rails.application.credentials.dig(:openai, :api_key)

    client = OpenAI::Client.new(access_token: api_key) # （1）
    system_content = <<~TEXT # （2）
        あなたはスクールカウンセラーです。
        生徒からの相談を受けています。
        生徒の話を受容と共感を持って聞くことが大切です。
        生徒との会話は一方通行ではなく、生徒の話に対して適切な質問を投げかけることで、
        生徒が自分の問題に気づくように導いてください。
        会話は概ね5ターン以内で終了するように、まとめて下さい。
        また、生徒の話が「ありがとう」や「さようなら」で終わった時は、
        生徒が納得したか確認して、生徒がこの話題を終了するように促してください。
        生徒が「終了」「ストップ」と言ったときは、会話を終了してください。
        あなたの回答は100文字以内にしてください。
    TEXT

    system_prompt = { "role" => "system", "content"=> system_content }

    latest_user = messages.reverse.find { |m| m[:role] == "user" || m["role"] == "user" }
    latest_assistant = messages.reverse.find { |m| m[:role] == "assistant" || m["role"] == "assistant" }

     chat_messages = [ system_prompt ]
     chat_messages << latest_assistant if latest_assistant
     chat_messages << latest_user if latest_user

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: chat_messages,
        max_tokens: 150,
        temperature: 0.7
     }
    )

    if response.dig("error", "message")
      "Error: #{response["error"]["message"]}"
    else
      response.dig("choices", 0, "message", "content")
    end
  end
end

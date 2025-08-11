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
      あなたは親しみやすく、落ち着いたカウンセラーです。
      丁寧で思いやりのある言葉づかいで返答してください。
      回答は100文字以内で簡潔にお願いします。
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
        max_tokens: 100,
        temperature: 0.7
     }
    )

  if response.dig("error", "message")
    return "Error: #{response["error"]["message"]}"
  else
    response.dig("choices", 0, "message", "content")
  end
  end
end

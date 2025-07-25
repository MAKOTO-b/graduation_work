require "test_helper"

class BotMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bot_messages_index_url
    assert_response :success
  end
end

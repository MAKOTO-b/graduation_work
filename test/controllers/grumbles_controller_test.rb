require "test_helper"

class GrumblesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get grumbles_new_url
    assert_response :success
  end

  test "should get create" do
    get grumbles_create_url
    assert_response :success
  end

  test "should get index" do
    get grumbles_index_url
    assert_response :success
  end
end

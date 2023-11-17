require "test_helper"

class MentionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get mentions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get mentions_destroy_url
    assert_response :success
  end
end

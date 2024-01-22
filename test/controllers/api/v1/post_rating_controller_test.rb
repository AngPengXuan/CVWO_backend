require "test_helper"

class Api::V1::PostRatingControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_post_rating_create_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_post_rating_show_url
    assert_response :success
  end
end

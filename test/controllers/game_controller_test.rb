require 'test_helper'

class GameControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get game_home_url
    assert_response :success
  end

  test "should get create_room" do
    get game_create_room_url
    assert_response :success
  end

  test "should get join_room" do
    get game_join_room_url
    assert_response :success
  end

end

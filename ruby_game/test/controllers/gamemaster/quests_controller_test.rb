require "test_helper"

class Gamemaster::QuestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gamemaster_quests_index_url
    assert_response :success
  end

  test "should get new" do
    get gamemaster_quests_new_url
    assert_response :success
  end

  test "should get create" do
    get gamemaster_quests_create_url
    assert_response :success
  end

  test "should get edit" do
    get gamemaster_quests_edit_url
    assert_response :success
  end

  test "should get update" do
    get gamemaster_quests_update_url
    assert_response :success
  end

  test "should get destroy" do
    get gamemaster_quests_destroy_url
    assert_response :success
  end
end

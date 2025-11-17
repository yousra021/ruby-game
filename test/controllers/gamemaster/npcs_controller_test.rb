require "test_helper"

class Gamemaster::NpcsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gamemaster_npcs_index_url
    assert_response :success
  end

  test "should get new" do
    get gamemaster_npcs_new_url
    assert_response :success
  end

  test "should get create" do
    get gamemaster_npcs_create_url
    assert_response :success
  end

  test "should get edit" do
    get gamemaster_npcs_edit_url
    assert_response :success
  end

  test "should get update" do
    get gamemaster_npcs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get gamemaster_npcs_destroy_url
    assert_response :success
  end
end

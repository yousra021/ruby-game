require "test_helper"

class Gamemaster::EquipmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gamemaster_equipments_index_url
    assert_response :success
  end

  test "should get new" do
    get gamemaster_equipments_new_url
    assert_response :success
  end

  test "should get create" do
    get gamemaster_equipments_create_url
    assert_response :success
  end

  test "should get edit" do
    get gamemaster_equipments_edit_url
    assert_response :success
  end

  test "should get update" do
    get gamemaster_equipments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get gamemaster_equipments_destroy_url
    assert_response :success
  end
end

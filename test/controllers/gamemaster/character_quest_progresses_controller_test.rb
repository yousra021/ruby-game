require "test_helper"

class Gamemaster::CharacterQuestProgressesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gamemaster_character_quest_progresses_index_url
    assert_response :success
  end

  test "should get show" do
    get gamemaster_character_quest_progresses_show_url
    assert_response :success
  end
end

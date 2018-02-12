require 'test_helper'

class StageSearchControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get stage_search_url
    assert_response :success
  end
end

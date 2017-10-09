require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    skip
    get users_create_url
    assert_response :success
  end

end

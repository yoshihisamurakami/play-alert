require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "ユーザー新規登録ページが正常に取得できること" do
    get signup_path
    assert_response :success
  end
end

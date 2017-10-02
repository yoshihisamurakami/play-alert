require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test@example.com", 
      regular: false,
    )
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "email がなければエラー" do
    @user.email = '  '
    assert_not @user.valid?
  end
  
  test "email が長すぎないこと" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end

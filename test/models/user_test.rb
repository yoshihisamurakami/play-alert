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
  
  test "email 正常なものを通すこと" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email 異常なフォーマットをエラー扱いする" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
end

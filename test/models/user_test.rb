require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test@example.com", 
      regular: false,
      name: 'murakami'
    )
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  test "name が空だったらエラー" do
    @user.name = '  '
    assert_not @user.valid?
  end
  
  test "name が　50文字より長ければエラー" do
    @user.name = "a" * 51
    assert_not @user.valid?
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

  test "email ユニークであること" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase  # 大文字・小文字を区別しない判定用
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email アドレスが小文字で保存されること" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
end

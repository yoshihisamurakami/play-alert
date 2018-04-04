require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:yoshihisa)
    remember(@user)
  end

  test "sessionがないとき正常にログインできること" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "remember digest フィールドの内容が違っているとき、正常にログインできないこと" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
require 'test_helper'

class UserStarTest < ActiveSupport::TestCase
  
  def setup
    user = users(:yoshihisa)
    stage = stages(:hamlet)
    @user_star = UserStar.new(
      user: user,
      stage: stage
      )
  end
  
  test "UserStar 正常データ" do
    assert @user_star.valid?
  end
  
  test "UserStar 異常データ user が nil だったらエラー" do
    @user_star.user = nil
    assert_not @user_star.valid?
  end
  
  test "UserStar 異常データ stage が nil だったらエラー" do
    @user_star.stage = nil
    assert_not @user_star.valid?
  end
end

require 'test_helper'

class AlertTest < ActiveSupport::TestCase
  def setup
    @stage = stages(:one)
    @user  = users(:one)
    @alert = Alert.new(
      stage: @stage, 
      user: @user,
      seven_days: false,
      three_days: false,
      one_day: true,
    )
  end
  
  test "should be valid" do
    assert @alert.valid?
  end
  
  test "stageがなければエラー" do
    @alert.stage_id = nil
    assert_not @alert.valid?
  end
  
  test "userがなければエラー" do
    @alert.user_id = nil
    assert_not @alert.valid?
  end
end

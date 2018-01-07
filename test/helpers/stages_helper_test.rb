require 'test_helper'


class StagesHelperTest < ActionView::TestCase
  test "datejapanのテスト" do
    @date = DateTime.parse("2018-01-01")
    assert_equal datejapan(@date), "2018年1月1日(月)"
    
    @date = DateTime.parse("2018-10-31")
    assert_equal datejapan(@date), "2018年10月31日(水)"
  end
  
  test "datejapan_shortのテスト" do
    @date = DateTime.parse("2018-01-01")
    assert_equal datejapan_short(@date), "1月1日(月)"
    
    @date = DateTime.parse("2018-10-31")
    assert_equal datejapan_short(@date), "10月31日(水)"
    
  end
end
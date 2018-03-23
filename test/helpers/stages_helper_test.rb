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
  
  test "later_weeksのテスト" do
    @date = DateTime.parse("2018-03-23")
    assert_equal nextweek_first(@date).strftime('%Y-%m-%d'), "2018-03-25", "2018-03-23 の翌週頭"
    assert_equal nextweek_last(@date).strftime('%Y-%m-%d'),  "2018-03-31", "2018-03-23 の翌週末"

    @date = DateTime.parse("2018-03-24")
    assert_equal nextweek_first(@date).strftime('%Y-%m-%d'), "2018-03-25", "2018-03-24 の翌週頭"
    assert_equal nextweek_last(@date).strftime('%Y-%m-%d'),  "2018-03-31", "2018-03-24 の翌週末"
    
    @date = DateTime.parse("2018-03-25")
    assert_equal nextweek_first(@date).strftime('%Y-%m-%d'), "2018-04-01", "2018-03-25 の翌週頭"
    assert_equal nextweek_last(@date).strftime('%Y-%m-%d'),  "2018-04-07", "2018-03-25 の翌週末"
  end
end
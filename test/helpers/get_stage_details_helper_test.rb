require 'test_helper'

class GetStageDetailsHelperTest < ActionView::TestCase
  def setup
    f = File.open("test/fixtures/stage_details.html")
    @html = f.read
    f.close
  end
  
  test "舞台の詳細情報を取得" do
    details = get_detailinfo(@html)
    assert_equal details[:cast], "[テスト出演者]"
    assert_equal details[:playwright], "[テスト脚本]"
    assert_equal details[:director], "[テスト演出]"
    assert_equal details[:price], "[テスト料金]"
    assert_equal details[:site], "http://example.com/"
    assert_equal details[:timetable], "1月1日(月) 12:00"
    
  end
end
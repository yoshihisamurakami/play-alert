require 'test_helper'

class StageTest < ActiveSupport::TestCase
  def setup
    @stage = Stage.new(
      url: "/stage/1", 
      title: "test",
      group: "test",
      theater: "test",
      startdate: "2017-08-13",
      enddate: "2017-08-13"
    )
  end

  test "should be valid" do
    assert @stage.valid?
  end
  
  test "urlがなければエラー" do
    @stage.url = '  '
    assert_not @stage.valid?
  end
  
  test "urlが256文字以上だったらエラー" do
    @stage.url = 'a' * 256
    assert_not @stage.valid?
  end
  
  test "titleがなければエラー" do
    @stage.title = ' '
    assert_not @stage.valid?
  end

  test "titleが256文字以上だったらエラー" do
    @stage.title = 'a' * 256
    assert_not @stage.valid?
  end

  test "groupがなければエラー" do
    @stage.group = ''
    assert_not @stage.valid?
  end

  test "groupが256文字以上だったらエラー" do
    @stage.group = 'a' * 256
    assert_not @stage.valid?
  end
  
  test "theaterがなければエラー" do
    @stage.theater = ''
    assert_not @stage.valid?
  end

  test "theaterが256文字以上だったらエラー" do
    @stage.theater = 'a' * 256
    assert_not @stage.valid?
  end

  test "startdateがなければエラー" do
    @stage.startdate = ''
    assert_not @stage.valid?
  end

  test "startdateが間違った日付ならエラー" do
    @stage.startdate= '2017-02-31'
    assert_not @stage.valid?
  end
  
  test "enddateがなければエラー" do
    @stage.enddate = ''
    assert_not @stage.valid?
  end

  test "enddateが間違った日付ならエラー" do
    @stage.enddate= '2017-09-31'
    assert_not @stage.valid?
  end
end

require 'test_helper'

class StageMailerTest < ActionMailer::TestCase
  
  def setup
    @mail_to = "muranet+rails@gmail.com"
    @alert = alerts(:one)
  end
  
  test "confirm" do
    mail = StageMailer.confirm(@mail_to, @alert)
    #assert_equal "PLAY ALERT 通知確認メールです", mail.subject
    assert_equal [@mail_to], mail.to
    assert_equal ["muranet+playalert@gmail.com"], mail.from
  end

  test "jobendメールが送信されること" do
    mail = StageMailer.jobend
    
    assert_equal "JOB実行しました", mail.subject
    assert_equal ["muranet+playalert@gmail.com"], mail.to
  end
end

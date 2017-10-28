require 'test_helper'

class StageMailerTest < ActionMailer::TestCase
  
  def setup
    @mail_to = "muranet+rails@gmail.com"
  end
  
  test "confirm" do
    mail = StageMailer.confirm(@mail_to)
    assert_equal "PLAY ALERT 通知確認メールです", mail.subject
    assert_equal [@mail_to], mail.to
    assert_equal ["muranet+playalert@gmail.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

end

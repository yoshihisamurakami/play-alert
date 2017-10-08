require 'test_helper'

class StageMailerTest < ActionMailer::TestCase
  test "confirm" do
    mail = StageMailer.confirm
    assert_equal "Confirm", mail.subject
    assert_equal ["muranet+rails@gmail.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

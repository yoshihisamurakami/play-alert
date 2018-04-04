class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "[PLAY ALERT] パスワード再設定"
  end
end

class StageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.stage_mailer.confirm.subject
  #
  def confirm(email)
    @greeting = "Hi"

    mail to: email, subject: "PLAY ALERT 通知確認メールです"
  end
end

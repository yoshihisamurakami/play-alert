class StageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.stage_mailer.confirm.subject
  #
  
  add_template_helper(StagesHelper)
  
  def confirm(email, alert)
    @alert = alert
    mail to: email, subject: "PLAY ALERT 通知確認メールです"
  end
  
  def jobend
    mail to: "muranet+playalert@gmail.com", subject: "JOB実行しました"
  end
end

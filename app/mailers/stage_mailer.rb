class StageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.stage_mailer.confirm.subject
  #
  
  add_template_helper(StagesHelper)
  
  def confirm(email, alert)
    @alert = alert
    mail to: email, subject: "[PLAY ALERT] 通知確認メールです"
  end
  
  def jobend
    mail to: "muranet+playalert@gmail.com", subject: "JOB実行しました"
  end
  
  def alert(alert)
    @alert = alert
    @days  = dayscount(alert)
    subject = "[PLAY ALERT] 公演開始日の%d日前になりました"%[dayscount(alert)]
    mail_to = alert.user.email
    mail to: mail_to, subject: subject
  end
  
  def contact(contact)
    @contact = contact
    subject = "[PLAY ALERT] お問い合わせが来ました。"
    mail to: "muranet+playalert@gmail.com", subject: subject
  end
  
  def dayscount(alert)
    today = Date.today
    diff = alert.stage.startdate - today
    return diff.to_i
  end
end

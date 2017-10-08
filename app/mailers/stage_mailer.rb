class StageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.stage_mailer.confirm.subject
  #
  def confirm
    @greeting = "Hi"

    mail to: "muranet+rails@gmail.com"
  end
end

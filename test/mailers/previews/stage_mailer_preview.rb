# Preview all emails at http://localhost:3000/rails/mailers/stage_mailer
class StageMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/stage_mailer/confirm
  def confirm
    StageMailer.confirm
  end

end

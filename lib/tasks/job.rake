namespace :job do
  desc "SendAlertMailJobを実行する"
  task sendalertmail: :environment do
    SendAlertMailJob.perform_now
  end

end

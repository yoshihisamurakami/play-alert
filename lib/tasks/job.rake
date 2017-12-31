namespace :job do
  desc "SendAlertMailJobを実行する"
  task sendalertmail: :environment do
    SendAlertMailJob.perform_now
  end


  task getStageDetails: :environment do
    GetStageDetailsJob.perform_now
  end
  
end

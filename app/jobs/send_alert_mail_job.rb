class SendAlertMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #puts "AlertMail送信処理 start.."
    logger.debug "AlertMail送信処理 start.."
    
    @alerts = Alert.all
    @alerts.each do |alert|
      puts record_info alert
      if need_send?(alert)
        StageMailer.alert(alert).deliver_now
      end
    end
    logger.debug "AlertMail送信処理 end.."
    #StageMailer.jobend.deliver_now
  end
  
  def record_info(alert)
    alert.id.to_s + "\t" + alert.stage.id.to_s + "\t" + alert.stage.title + "\t"+ alert.stage.startdate.to_s
  end
  
  def need_send?(alert)
    today = Date.today
    diff = alert.stage.startdate - today
    return true if alert.one_day    and diff.to_i == 1
    return true if alert.three_days and diff.to_i == 3
    return true if alert.seven_days and diff.to_i == 7 
    false
  end
  
  def dayscount(alert)
    today = Date.today
    diff = alert.stage.startdate - today
    return diff.to_i
  end
end

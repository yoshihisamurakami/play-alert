class KeepaliveJob < ApplicationJob
  queue_as :default

  include KeepaliveHelper
  
  def perform(*args)
    now = DateTime.now
    logger.debug('KeepaliveJob: hour=> ' + now.hour.to_s + ' minute => ' + now.minute.to_s)
    keepalive_website if need_keepalive?(now.hour, now.minute)
  end
end

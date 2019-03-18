class KeepaliveJob < ApplicationJob
  queue_as :default

  include KeepaliveHelper
  
  def perform(*args)
    now = DateTime.now
    keepalive_website if need_keepalive?(now.hour, now.minute)
  end
end

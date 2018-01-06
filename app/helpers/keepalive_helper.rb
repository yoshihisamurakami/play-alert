require 'open-uri'

module KeepaliveHelper

  KEEPALIVE_URL = "https://playalert.herokuapp.com/help"
  
  def need_keepalive?(hour, minute)
    sleeptime = 0..7
    return false if sleeptime.include?(hour)
    return true if (0..9).include?(minute)
    return true if (30..39).include?(minute)
    false
  end

  def keepalive_website
    file = open(KEEPALIVE_URL)
  end

end
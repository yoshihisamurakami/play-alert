require 'open-uri'

module KeepaliveHelper

  KEEPALIVE_URL = "https://playalert.herokuapp.com/help"
  WORKING_HOURS = 13..21
  #
  # 日本時間にて13:00～21:00にwebが起動されている状態にしたい
  def need_keepalive?(hour, minute)
    return false unless WORKING_HOURS.include?(hour)
    return true if (0..9).include?(minute)
    return true if (30..39).include?(minute)
    false
  end

  def keepalive_website
    file = open(KEEPALIVE_URL)
  end

end
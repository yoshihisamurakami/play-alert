
module StagesHelper

  def dayoftheweek(date)
    %w(日 月 火 水 木 金 土 日)[date.cwday]
  end
  
  # 2017-10-18 ->  2017年10月18日(水) 
  def datejapan(date)
    year  = date.to_s[0, 4]
    month = date.to_s[5, 2]
    day   = date.to_s[8, 2]
    year + "年" + month + "月" + day + "日(" + dayoftheweek(date) + ")"
  end
  
  def datejapan_short(date)
    month = date.to_s[5, 2]
    day   = date.to_s[8, 2]
    month + "月" + day + "日(" + dayoftheweek(date) + ")"
  end
  
  def glyphicon_star(stage_id)
    stars.include?(stage_id.to_s) ? "glyphicon-star" : "glyphicon-star-empty"
  end
  
  def is_visible?(str)
    return false if str.nil?
    return false if str.strip.empty?
    true
  end
end

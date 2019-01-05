
module StagesHelper
  CWDAY_SATURDAY = 6
  CWDAY_SUNDAY   = 7
  
  def dayoftheweek(date)
    %w(日 月 火 水 木 金 土 日)[date.cwday]
  end
  
  # 2017-10-18 ->  2017年10月18日(水) 
  def datejapan(date)
    if m = date.to_s.match(/(?<year>\d+)-(?<month>\d+)-(?<day>\d+)/)
      m[:year] + "年" + cut_firstzero(m[:month]) + "月" + cut_firstzero(m[:day]) + "日" + "(" + dayoftheweek(date) + ")"
    else 
      ''
    end
  end
  
  def datejapan_short(date)
    if m = date.to_s.match(/(?<year>\d+)-(?<month>\d+)-(?<day>\d+)/)
      cut_firstzero(m[:month]) + "月" + cut_firstzero(m[:day]) + "日" + "(" + dayoftheweek(date) + ")"
    else
      ''
    end
  end
  
  def cut_firstzero(str)
    str.gsub(/0([1-9])/, '\1')
  end
  
  def glyphicon_star(stage_id)
    stars.include?(stage_id.to_s) ? "glyphicon-star" : "glyphicon-star-empty"
  end
  
  def is_visible?(str)
    return false if str.nil?
    return false if str.strip.empty?
    true
  end
  
  def stagenavi_onoff(viewname)
    return ' on' if @view == viewname
    ''
  end
  
  def stagelist_title_class
    if @view == 'playing'
      'nowplaying'
    elsif @view == 'later'
      'later'
    else
      ''
    end
  end
  
  def firstofweek(date)
    return date if date.cwday == CWDAY_SUNDAY
    firstofweek date - 1
  end

  def lastofweek(date)
    return date if date.cwday == CWDAY_SATURDAY
    lastofweek date + 1
  end
  
  def nextweek_first(date)
    date += 7
    firstofweek date
  end
  
  def nextweek_last(date)
    date += 7
    lastofweek date
  end

  def lastweek_first(date)
    date -= 7
    firstofweek date
  end

  def prevweek_first
    firstday = lastweek_first Date.strptime(params[:start], '%Y%m%d')
    return nil if Stage.count_on_week(firstday) == 0
    firstday
  end

end

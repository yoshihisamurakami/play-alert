require 'date'

module StagesHelper

  def dayoftheweek(date)
    %w(日 月 火 水 木 金 土 日)[date.cwday]
  end
end

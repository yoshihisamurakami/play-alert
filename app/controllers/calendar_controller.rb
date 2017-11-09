class CalendarController < ApplicationController
  def index
    @datas = [
      'title' => "クリスマス",
      'start' => "2017-11-24 00:00:00",
      'end'   => "2017-11-25 23:00:00",
    ]
  end
end

class CalendarController < ApplicationController
  def index
    @datas = [
      'title' => "クリスマス",
      'start' => "2017-12-24",
      'end'   => "2017-12-25 23:00:00",
    ]
  end
end

class CalendarController < ApplicationController
  def index
    @debug = ''
    @datas = []
    @stages = Stage.where(id: stars)
    @stages.each do |stage|
      @datas += [
        'title' => stage.group + " " + stage.title,
        'start' => stage.startdate.to_s + " 00:00:00",
        'end' => stage.enddate.to_s + " 23:59:59",
        'url' => stage_path(stage.id),
      ]
    end
  end

end

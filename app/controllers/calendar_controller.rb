class CalendarController < ApplicationController
  def index
    @debug = ''
    @data = []
    colors = ['#38a', '#f99', '#5b5', '#45b']
    @stages = Stage.where(id: stars).order(:startdate)
    i = 0
    @stages.each do |stage|
      @data += [
        'title' => stage.group + " " + stage.title,
        'start' => stage.startdate.to_s + " 00:00:00",
        'end' => stage.enddate.to_s + " 23:59:59",
        'url' => stage_path(stage.id),
        'color' => colors[i % 4],
      ]
      i += 1
    end
  end

end

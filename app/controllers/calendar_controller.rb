class CalendarController < ApplicationController
  CALENDAR_COLORS = ['#38a', '#f99', '#5b5', '#45b']

  def index
    @stages = Stage.where(id: stars).order(:startdate)
    @data = get_calenders_data(@stages)
  end

  private

  def get_calenders_data(stages)
    data = []
    stages.each_with_index do |stage, i|
      data += [
        title: stage.group + " " + stage.title,
        start: stage.startdate.to_s + " 00:00:00",
        end: stage.enddate.to_s + " 23:59:59",
        url: stage_path(stage.id),
        color: CALENDAR_COLORS[i % CALENDAR_COLORS.count],
      ]
    end
    data
  end
end

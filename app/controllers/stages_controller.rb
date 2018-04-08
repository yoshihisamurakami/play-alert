class StagesController < ApplicationController
  include StagesHelper
  before_action :set_stages_on_weeks, only: [:playing, :thisweek, :later]
  
  def show
    @stage = Stage.find(params[:id])
    @alert = Alert.new
  end
  
  def detail
    @stage_detail = StageDetail.find_by(stage_id: params[:id])
    if @stage_detail
      render json: @stage_detail.json
    else
      render json: {status: "notfound"}
    end
  end
  
  def playing
    @stages = Stage.playing
    @view = 'playing'
    render :index
  end
  
  def thisweek
    @stages = Stage.thisweek
    @view = 'thisweek'
    render :index
  end
  
  def later
    if params[:start].nil?
      last  = lastofweek(Date.today)
      @stages = Stage
        .where("startdate > ?", last)
        .order(:startdate, :id)
        .page(params[:page])
    else
      @stages = Stage.later(1, params[:start])
    end
    
    @view = 'later'
    render :index
  end
  
  private
  
  def set_stages_on_weeks
    date = Date.today
    @stages_on_weeks = []
    loop do
      firstday = nextweek_first date
      count = Stage.count_on_week(firstday)
      break if count == 0
      @stages_on_weeks.push({
        firstday: firstday,
        size: count
      })
      date = firstday
    end
  end

end

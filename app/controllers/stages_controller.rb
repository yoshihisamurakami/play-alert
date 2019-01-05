class StagesController < ApplicationController
  include StagesHelper
  before_action :set_area, only: [:playing, :thisweek, :later]
  before_action :set_stages_on_weeks, only: [:playing, :thisweek, :later]
  before_action :set_prevweek_link, only: [:thisweek, :later]
  before_action :set_nextweek_link, only: [:thisweek, :later]
  
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
    @stages = Stage.playing @area
    @view = 'playing'
    render :index
  end
  
  def thisweek
    @stages = Stage.thisweek @area
    @view = 'thisweek'
    render :index
  end
  
  def later
    if params[:start].nil?
      last  = lastofweek(Date.today)
      @stages = Stage
        .where("startdate > ?", last)
        .where(area: @area)
        .order(:startdate, :id)
        .page(params[:page])
    else
      @stages = Stage.later(@area, 1, params[:start])
    end
    @view = 'later'
    render :index
  end

  def set_area
    @area = session[:area] || Constants::AREA_KANTO
  end

  private

  def set_stages_on_weeks
    date = Date.today
    @stages_on_weeks = []
    loop do
      firstday = nextweek_first date
      count = Stage.count_on_week(@area, firstday)
      break if count == 0
      @stages_on_weeks.push({
        firstday: firstday,
        text: firstday.strftime('%Y-%m-%d') + "〜" + (firstday + 6).strftime('%Y-%m-%d') + " (#{count}件)",
        url: "/stages/later?start=" + firstday.strftime('%Y%m%d'),
        size: count
      })
      date = firstday
    end
  end

  def set_prevweek_link
    return if @stages_on_weeks.nil? or @stages_on_weeks.empty?
    return if params[:start].nil?
    idx = 0
    @stages_on_weeks.each_with_index do |sw, i|
      if sw[:url].match(params[:start])
        idx = i - 1
        break
      end
    end
    url = idx < 0 ? '/stages/thisweek' : @stages_on_weeks[idx][:url]
    @prevweek_link = url.nil? ? nil : { text: '←前の週', url: url }
  end

  def set_nextweek_link
    return if @stages_on_weeks.nil? or @stages_on_weeks.empty?
    if params[:start].nil?
      url = @stages_on_weeks.first[:url]
    else
      idx = 0
      @stages_on_weeks.each_with_index do |sw, i|
        if sw[:url].match(params[:start])
          idx = i + 1
          break
        end
      end
      if @stages_on_weeks.count == idx
        url = nil
      else
        url = @stages_on_weeks[idx][:url]
      end
    end
    @nextweek_link = url.nil? ? nil : { text: '次の週→', url: url }
  end
end

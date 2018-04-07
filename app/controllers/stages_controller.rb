class StagesController < ApplicationController
  include StagesHelper
  before_action :set_stages_on_weeks
  
  def index
    today = Date.today
    @stages = Stage
      .where("startdate > ?", today)
      .order(:startdate, :id)
      .page(params[:page])
  end
  
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
    #@stages = Stage
    #  .where("startdate <= ?", Date.today)
    #  .order(:startdate, :id)
    #  .page(params[:page])
    #return render json: stages_json if params[:type] == 'json'
    @stages = Stage.playing
    @view = 'playing'
    render :index
  end
  
  def thisweek
    first = firstofweek(Date.today)
    last  = lastofweek(Date.today)
    @stages = Stage
      .where("startdate >= ?", first)
      .where("startdate <= ?", last)
      .order(:startdate, :id)
      .page(params[:page])
    return render json: stages_json if params[:type] == 'json'
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
      start = DateTime.strptime(params[:start], "%Y%m%d")
      @stages = Stage
        .where("startdate >= ?", start)
        .where("startdate <= ?", start + 6)
        .order(:startdate, :id)
        .page(params[:page])
    end
    
    return render json: stages_json if params[:type] == 'json'
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

  def stages_json
    @stages.inject([]) do |json, stage|
      json.push(stage_json stage)
    end
  end

  def stage_json(stage)
    hash = stage.attributes.symbolize_keys.slice(:id, :title, :group, :startdate, :theater)
    hash.merge({
      url: stage_path(stage.id),
      startdatej: datejapan(stage.startdate),
      term: stage.term,
      glyphicon_star: glyphicon_star(stage.id),
    })
  end
end

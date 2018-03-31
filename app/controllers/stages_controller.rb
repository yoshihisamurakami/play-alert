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
    @stage_detail = StageDetail.find_by(stage_id: @stage.id)
    @alert = Alert.new
  end
  
  def detail
    @stage_detail = StageDetail.find_by(stage_id: params[:id])
    if @stage_detail
      json = detail_json
      render json: json
    else
      render json: {status: "notfound"}
    end
  end
  
  def playing
    @stages = Stage
      .where("startdate <= ?", Date.today)
      .order(:startdate, :id)
      .page(params[:page])
    return render json: stages_json if params[:type] == 'json'
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
      count = oneweek_stages_count firstday
      break if count == 0
      @stages_on_weeks.push({
        firstday: firstday,
        size: count,
      })
      date = firstday
    end
  end
  
  def oneweek_stages_count(firstday_of_week)
    Stage
      .where("startdate >= ?", firstday_of_week)
      .where("startdate <= ?", firstday_of_week + 6)
      .size
  end
  
=begin  
  def firstofweek(date)
    return date if date.cwday == 7
    firstofweek(date-1)
  end

  def lastofweek(date)
    return date if date.cwday == 6
    lastofweek(date+1)
  end
=end

  def stages_json
    json = []
    @stages.each do |stage|
      json.push(
        id: stage.id,
        url: stage_path(stage.id),
        title: stage.title,
        group: stage.group,
        startdate: stage.startdate,
        startdatej: datejapan(stage.startdate),
        term: stage.term,
        theater: stage.theater,
        glyphicon_star: glyphicon_star(stage.id),
      )
    end
    json
  end
  
  def detail_json
    {
      playwright: is_visible?(@stage_detail.playwright) ? @stage_detail.playwright : '',
      director: is_visible?(@stage_detail.director) ? @stage_detail.director : '',
      cast: is_visible?(@stage_detail.cast) ? @stage_detail.cast : '',
      price: is_visible?(@stage_detail.price) ? @stage_detail.price : '',
      timetable: is_visible?(@stage_detail.timetable) ? @stage_detail.timetable : '',
      site: is_visible?(@stage_detail.site) ? @stage_detail.site : '',
    }
  end
end

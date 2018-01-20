class StagesController < ApplicationController
  include StagesHelper

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
  
  def playing
    @stages = Stage
      .where("startdate <= ?", Date.today)
      .order(:startdate, :id)
      .page(params[:page])
    return render json: stages_json if params[:type] == 'json'
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
    render :index
  end
  
  def later
    last  = lastofweek(Date.today)
    @stages = Stage
      .where("startdate > ?", last)
      .order(:startdate, :id)
      .page(params[:page])
    return render json: stages_json if params[:type] == 'json'
    render :index
  end
  
  private
  
  def firstofweek(date)
    return date if date.cwday == 7
    firstofweek(date-1)
  end
  
  def lastofweek(date)
    return date if date.cwday == 6
    lastofweek(date+1)
  end

  def stages_json
    json = []
    @stages.each do |stage|
      json.push(
        id: stage.id,
        url: stage_path(stage.id),
        title: stage.title,
        group: stage.group,
        startdate: stage.startdate,
        term: stage.term,
        theater: stage.theater,
        glyphicon_star: glyphicon_star(stage.id),
      )
    end
    json
  end
  
end

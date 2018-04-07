
class StagesJsonController < StagesController

  def playing
    page = params[:page] ? params[:page] : 1
    @stages = Stage.playing page
    render json: stages_json
  end
  
  def thisweek
    page = params[:page] ? params[:page] : 1
    @stages = Stage.thisweek page
    render json: stages_json
  end
  
  def later
    page = params[:page] ? params[:page] : 1
    start = params[:start] ? params[:start] : ''
    @stages = Stage.later(page, start)
    render json: stages_json
  end
  
  private
  
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
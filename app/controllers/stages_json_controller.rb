class StagesJsonController < StagesController
  before_action :set_page
  
  def playing

    @stages = Stage.playing @page
    render json: stages_json
  end
  
  def thisweek
    @stages = Stage.thisweek @page
    render json: stages_json
  end
  
  def later
    start = params[:start] ? params[:start] : ''
    @stages = Stage.later(@page, start)
    render json: stages_json
  end
  
  private
  
  def set_page
    @page = params[:page] ? params[:page] : 1
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
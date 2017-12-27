class StagesController < ApplicationController
  def index
    today = Date.today
    @stages = Stage
      .where("startdate > ?", today)
      .order(:startdate, :id)
      .page(params[:page])

    @star_class = {}
    @stages.each do |stage|
      if stars.include?(stage.id.to_s)
        @star_class[stage.id] = 'glyphicon-star'
      else
        @star_class[stage.id] = 'glyphicon-star-empty'
      end
    end
    
  end
  
  def show
    @stage = Stage.find(params[:id])
    @alert = Alert.new
  end
  
end

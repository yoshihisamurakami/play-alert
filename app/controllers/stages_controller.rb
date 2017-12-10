class StagesController < ApplicationController
  def index
    today = Date.today
    @stages = Stage.where("startdate > ?", today).order(:startdate, :id).page(params[:page])
    @alert = Alert.new
    
    star_str = cookies.signed[:stars]
    star = (star_str) ? star_str.split(',') : []
    @star_class = {}
    @stages.each do |stage|
      if star.include?(stage.id.to_s)
        @star_class[stage.id] = 'glyphicon-star'
      else
        @star_class[stage.id] = 'glyphicon-star-empty'
      end
    end
    
  end
  
  def show
    @stage = Stage.find(params[:id])
    @user  = User.new
    @alert = Alert.new
  end
end

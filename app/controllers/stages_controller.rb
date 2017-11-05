class StagesController < ApplicationController
  def index
    today = Date.today
    @stages = Stage.where("startdate > ?", today).order(:startdate, :id).page(params[:page])
  end
  
  def show
    @stage = Stage.find(params[:id])
    @user  = User.new
    @alert = Alert.new
  end
end

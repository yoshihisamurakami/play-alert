class StagesController < ApplicationController
  def index
    @stages = Stage.order(:startdate).page(params[:page])
  end
  
  def show
    @stage = Stage.find(params[:id])
    @user  = User.new
    @alert = Alert.new
  end
end

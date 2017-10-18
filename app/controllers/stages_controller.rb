class StagesController < ApplicationController
  def index
    @stages = Stage.order(:startdate, :id).page(params[:page])
  end
  
  def show
    @stage = Stage.find(params[:id])
    @user  = User.new
    @alert = Alert.new
  end
end

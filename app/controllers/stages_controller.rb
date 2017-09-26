class StagesController < ApplicationController
  def index
    @stages = Stage.page(params[:page])
  end
  
  def show
    @stage = Stage.find(params[:id])
  end
end

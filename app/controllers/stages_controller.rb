class StagesController < ApplicationController
  def index
    @stages = Stage.page(params[:page])
  end
end

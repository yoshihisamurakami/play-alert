class AreaController < ApplicationController
  def create
    @data = { area: params[:area] }
    session[:area] = get_area_from_params
    render json: @data
  end

  private
  
  def get_area_from_params
    if params[:area] == 'east'
      Constants::AREA_KANTO
    elsif params[:area] == 'west'
      Constants::AREA_KINKI
    else
      nil
    end
  end
end
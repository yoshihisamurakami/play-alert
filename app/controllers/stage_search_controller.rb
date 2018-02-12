class StageSearchController < ApplicationController

  def index
    @stage_search = StageSearch.new
  end
  
  def search
    @stages = StageSearch.search(search_params)
  end
  
  private
  
  def search_params
    params.require(:stage_search).permit(
        :word,
      )
  end
end
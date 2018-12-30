class GetStagesRoughInfoJob < ApplicationJob
  queue_as :default

  def perform(*args)
    p "GetStagesRoughInfo start.."
    delete_past_stages
    
    urls = GetStages.execute :order_by_startdate
    urls_new = GetStages.execute :orderby_new_arrivals
  end
  
  # 公演最終日が前日より前の舞台情報は削除する
  def delete_past_stages
    p "delete_past_stages"
    yesterday = Date.today - 1
    Stage.where("enddate <= ?", yesterday).destroy_all
  end

end

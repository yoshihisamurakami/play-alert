class GetStagesRoughInfoJob < ApplicationJob
  queue_as :default

  AREA_KANTO = '3' # 関東地方
  AREA_KINKI = '8' # 近畿地方

  def perform(*args)
    p "GetStagesRoughInfo start.."
    delete_past_stages
    
    urls = GetStages.execute(:order_by_startdate, AREA_KANTO)
    urls_new = GetStages.execute(:orderby_new_arrivals, AREA_KANTO)
    urls_kinki =  GetStages.execute(:order_by_startdate, AREA_KINKI)
    urls_kinki_new = GetStages.execute(:orderby_new_arrivals, AREA_KINKI)
  end
  
  # 公演最終日が前日より前の舞台情報は削除する
  def delete_past_stages
    p "delete_past_stages"
    yesterday = Date.today - 1
    Stage.where("enddate <= ?", yesterday).destroy_all
  end

end

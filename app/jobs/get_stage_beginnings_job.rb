class GetStageBeginningsJob < ApplicationJob
  queue_as :default

  # Corich「もうすぐ開幕する公演」一覧ページから舞台情報を取得
  def perform(*args)
    p "Get Stage biginnings start.."
    
    delete_past_stages
    GetStages.execute :order_by_startdate
  end

  # 公演最終日が前日より前の舞台情報は削除する
  def delete_past_stages
    p "delete_past_stages"
    yesterday = Date.today - 1
    Stage.where("enddate <= ?", yesterday).destroy_all
  end

end

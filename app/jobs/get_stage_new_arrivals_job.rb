class GetStageNewArrivalsJob < ApplicationJob
  queue_as :default

  # Corich「新着公演」一覧ページから舞台情報を取得
  def perform(*args)
    p "Get Stage new arrivals start.."
    GetStages.execute :orderby_new_arrivals
  end

end
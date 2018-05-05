class GetStageBeginningsJob < ApplicationJob
  queue_as :default
  
  STAGES_URL = 'http://stage.corich.jp/stage/start'.freeze
  STAGES_DOMAIN = 'http://stage.corich.jp'.freeze
  TIMEOUT = 10.freeze
  
  #include GetStageDetailsHelper
  
  # Corich「もうすぐ開幕する公演」一覧ページから舞台情報を取得
  def perform(*args)
    p "Get Stage biginnings start.."
    #get_stage_details
    
    delete_past_stages
  end
  
  def delete_past_stages
    p "delete_past_stages"
  end
end

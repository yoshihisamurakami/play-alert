class GetStageDetailsJob < ApplicationJob
  queue_as :default
  
  include GetStageDetailsHelper
  
  def perform(*args)
    p "Get StageDetails job start.."
    get_stage_details
  end
end

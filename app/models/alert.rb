class Alert < ApplicationRecord
  belongs_to :stage
  belongs_to :user
  validates  :stage_id, presence: true
  validates  :user_id,  presence: true
  
  validate :is_valid_sending_days
  
  # 全部falseだったらダメ
  def is_valid_sending_days
    if !seven_days && !three_days && !one_day
      errors.add(:one_day, '7,3,1日前どれか１つは必ずチェックしてください')
    end
  end
end

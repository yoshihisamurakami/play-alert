class Alert < ApplicationRecord
  belongs_to :stage
  belongs_to :user
  validates  :stage_id, presence: true
  validates  :user_id,  presence: true
end

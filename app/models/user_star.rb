class UserStar < ApplicationRecord
  belongs_to :user
  belongs_to :stage
  validates :user_id,  presence: true, :uniqueness => {:scope => :stage_id}
  validates :stage_id, presence: true
end

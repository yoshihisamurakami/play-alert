class Stage < ApplicationRecord
  validates :url,     presence: true, length: { maximum: 255 }
  validates :title,   presence: true, length: { maximum: 255 }
  validates :group,   presence: true, length: { maximum: 255 }
  validates :theater, presence: true, length: { maximum: 255 }
  validates :startdate, presence: true
  validates :enddate,   presence: true
end

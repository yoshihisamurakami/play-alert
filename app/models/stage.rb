class Stage < ApplicationRecord
  validates :url,     presence: true, length: { maximum: 255 }
  validates :title,   presence: true, length: { maximum: 255 }
  validates :group,   presence: true, length: { maximum: 255 }
  validates :theater, presence: true, length: { maximum: 255 }
  validates :startdate, presence: true
  validates :enddate,   presence: true
  has_many :alerts, dependent: :destroy
  has_many :user_stars, dependent: :destroy
  has_one :stage_detail, dependent: :destroy

  include StagesHelper

  def term
    return datejapan_short(startdate) if startdate == enddate
    datejapan_short(startdate) + "〜 " + datejapan_short(enddate) 
  end

end

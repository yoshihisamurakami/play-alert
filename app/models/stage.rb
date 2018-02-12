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

  def self.search(word)
    relation = Stage.joins(:stage_detail)
    relation
      .merge(Stage.where("title ILIKE ?", "%#{sanitize_sql_like(word)}%"))
      .or(relation.where("\"group\" ILIKE ?", "%#{sanitize_sql_like(word)}%"))
      .or(relation.where("theater ILIKE ?", "%#{sanitize_sql_like(word)}%"))
      .or(relation.where("stage_details.playwright ILIKE ?",  "%#{sanitize_sql_like(word)}%"))
      .or(relation.where("stage_details.director ILIKE ?",  "%#{sanitize_sql_like(word)}%"))
      .or(relation.where("stage_details.cast ILIKE ?",  "%#{sanitize_sql_like(word)}%"))
      .order(:startdate)
  end
end

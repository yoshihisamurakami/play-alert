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

  class << self
    include StagesHelper
    def search(word)
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
  
    def count_on_week(firstday_of_week)
      Stage
        .where("startdate >= ?", firstday_of_week)
        .where("startdate <= ?", firstday_of_week + 6)
        .size
    end
  
    def playing(page=1)
      Stage
        .where("startdate <= ?", Date.today)
        .order(:startdate, :id)
        .page(page)
    end
    
    def thisweek(page=1)
      first = firstofweek(Date.today)
      last  = lastofweek(Date.today)
      Stage
        .where("startdate >= ?", first)
        .where("startdate <= ?", last)
        .order(:startdate, :id)
        .page(page)
    end
    
    def later(page, start)
      start = DateTime.strptime(start, "%Y%m%d")
      Stage
        .where("startdate >= ?", start)
        .where("startdate <= ?", start + 6)
        .order(:startdate, :id)
        .page(page)
    end
    
  end
end

class AddCrawlDateOnStageDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :stage_details, :crawl_date, :datetime
  end
end

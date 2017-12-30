class CreateStageDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_details do |t|
      t.references :stage, foreign_key: true
      t.text :cast
      t.text :playwright
      t.text :director
      t.text :price
      t.text :site
      t.text :timetable

      t.timestamps
    end
  end
end

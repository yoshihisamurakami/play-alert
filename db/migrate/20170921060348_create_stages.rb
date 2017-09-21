class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.string :url
      t.string :title
      t.string :group
      t.string :theater
      t.date :startdate
      t.date :enddate

      t.timestamps
    end
  end
end

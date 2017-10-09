class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.references :stage, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :seven_days, default: false, null: false
      t.boolean :three_days, default: false, null: false
      t.boolean :one_day,    default: false, null: false

      t.timestamps
    end
  end
end

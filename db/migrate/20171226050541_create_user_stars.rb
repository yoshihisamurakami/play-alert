class CreateUserStars < ActiveRecord::Migration[5.1]
  def change
    create_table :user_stars do |t|
      t.references :user, foreign_key: true
      t.references :stage, foreign_key: true

      t.timestamps
    end
    add_index  :user_stars, [:user_id, :stage_id], unique: true
  end
end

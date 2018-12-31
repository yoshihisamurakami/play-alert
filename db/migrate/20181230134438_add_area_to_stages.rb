class AddAreaToStages < ActiveRecord::Migration[5.1]
  def change
    add_column :stages, :area, :integer
  end
end

class AddColumnsToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :current_player, :integer
    add_column :games, :turn_order, :integer, array: true
  end
end

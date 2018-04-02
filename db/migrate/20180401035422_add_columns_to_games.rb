class AddColumnsToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :trash, :string, array: true
    add_column :games, :status, :integer, default: 0
    change_column :turns, :cards_bought, :cards_gained
    add_column :turns, :cards_trashed, :string, array: true
  end
end

class RemovePlayerIdFromDecks < ActiveRecord::Migration[5.1]
  def change
    remove_column :decks, :player_id
  end
end

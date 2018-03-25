class CreateDecks < ActiveRecord::Migration[5.1]
  def change
    create_table :decks do |t|
      t.references :player, foreign_key: true
      t.references :game, foreign_key: true
      t.integer :draw, array: true
      t.integer :discard, array: true

      t.timestamps
    end
  end
end

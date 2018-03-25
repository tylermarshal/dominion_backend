class CreateGameCards < ActiveRecord::Migration[5.1]
  def change
    create_table :game_cards do |t|
      t.references :game, foreign_key: true
      t.references :card, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end

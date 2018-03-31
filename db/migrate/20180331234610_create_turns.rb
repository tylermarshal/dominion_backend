class CreateTurns < ActiveRecord::Migration[5.1]
  def change
    create_table :turns do |t|
      t.references :game, foreign_key: true
      t.references :competitor, foreign_key: true
      t.integer :coins
      t.string :cards_played, array: true
      t.string :cards_bought, array: true

      t.timestamps
    end
  end
end

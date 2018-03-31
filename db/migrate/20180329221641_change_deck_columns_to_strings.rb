class ChangeDeckColumnsToStrings < ActiveRecord::Migration[5.1]
  def change
    change_column :decks, :draw, :string, array: true
    change_column :decks, :discard, :string, array: true
  end
end

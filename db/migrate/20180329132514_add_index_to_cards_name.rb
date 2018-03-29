class AddIndexToCardsName < ActiveRecord::Migration[5.1]
  def change
    add_index :cards, :name
  end
end

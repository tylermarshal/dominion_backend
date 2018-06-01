class AddLastPokeToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :last_poke, :datetime    
  end
end

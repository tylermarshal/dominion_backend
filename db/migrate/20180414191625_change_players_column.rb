class ChangePlayersColumn < ActiveRecord::Migration[5.1]
  def change
		enable_extension("citext")
		change_column :players, :username, :citext
  end
end

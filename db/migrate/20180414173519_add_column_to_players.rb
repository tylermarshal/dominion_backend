class AddColumnToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :username, :string
    add_column :players, :password_digest, :string
    add_column :players, :phone_number, :string
  end
end

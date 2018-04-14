class AddColumnToPlayer < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :token, :string
  end
end

class ChangeCardsToCiText < ActiveRecord::Migration[5.1]
  def change
    enable_extension("citext")
    change_column :cards, :name, :citext
    change_column :cards, :set, :citext
  end
end

class ChangeTypeToAttackCard < ActiveRecord::Migration[5.1]
  def change
    rename_column :cards, :type, :attack
  end
end

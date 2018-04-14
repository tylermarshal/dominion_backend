class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.references :player, foreign_key: true
      t.integer :friend_id

      t.timestamps
    end
  end
end

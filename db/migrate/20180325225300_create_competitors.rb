class CreateCompetitors < ActiveRecord::Migration[5.1]
  def change
    create_table :competitors do |t|
      t.references :game, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end

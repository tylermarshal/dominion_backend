class AddCompetitorsToDecks < ActiveRecord::Migration[5.1]
  def change
    add_reference :decks, :competitor, index: true
  end
end

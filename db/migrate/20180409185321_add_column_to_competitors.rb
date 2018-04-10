class AddColumnToCompetitors < ActiveRecord::Migration[5.1]
  def change
		add_column :competitors, :attacks, :string, array: true, default: []
  end
end

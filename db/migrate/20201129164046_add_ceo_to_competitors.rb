class AddCeoToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :ceo, :string, default: "NA"
  end
end

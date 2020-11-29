class AddEquityToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :equity, :string, default: "NA"
  end
end

class AddTradingNameToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :trading_name, :string
  end
end

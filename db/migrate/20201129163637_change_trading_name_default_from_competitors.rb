class ChangeTradingNameDefaultFromCompetitors < ActiveRecord::Migration[6.0]
  def change
    change_column_default :competitors, :trading_name, "NA"
    change_column_default :competitors, :summary, "NA"
  end
end

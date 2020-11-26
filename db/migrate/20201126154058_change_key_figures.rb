class ChangeKeyFigures < ActiveRecord::Migration[6.0]
  def change
      change_column_default :key_figures, :close, "NA"
      change_column_default :key_figures, :turnover, "NA"
      change_column_default :key_figures, :profit, "NA"
      change_column_default :key_figures, :workforce, "NA"
  end
end

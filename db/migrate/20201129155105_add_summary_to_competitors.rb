class AddSummaryToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :summary, :text
  end
end

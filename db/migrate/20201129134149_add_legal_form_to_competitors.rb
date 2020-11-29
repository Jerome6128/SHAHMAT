class AddLegalFormToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :legal_form, :string, default: "NA"
  end
end

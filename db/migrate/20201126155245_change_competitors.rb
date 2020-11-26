class ChangeCompetitors < ActiveRecord::Migration[6.0]
  def change
    change_column_default :competitors, :brand_name, "NA"
    change_column_default :competitors, :address, "NA"
    change_column_default :competitors, :website, "NA"
    change_column_default :competitors, :siren, "NA"
    change_column_default :competitors, :rcs, "NA"
    change_column_default :competitors, :siret, "NA"
    change_column_default :competitors, :naf, "NA"
  end
end

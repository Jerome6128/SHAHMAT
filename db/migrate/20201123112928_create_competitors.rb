class CreateCompetitors < ActiveRecord::Migration[6.0]
  def change
    create_table :competitors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :brand_name
      t.string :address
      t.string :website
      t.string :siren
      t.string :rcs
      t.string :siret
      t.string :naf

      t.timestamps
    end
  end
end

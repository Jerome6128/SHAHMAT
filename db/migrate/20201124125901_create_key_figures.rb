class CreateKeyFigures < ActiveRecord::Migration[6.0]
  def change
    create_table :key_figures do |t|
      t.string :close
      t.string :turnover
      t.string :profit
      t.string :workforce
      t.references :competitor, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateJobOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :job_offers do |t|
      t.string :title
      t.string :location
      t.date :posting_date
      t.references :competitor, null: false, foreign_key: true

      t.timestamps
    end
  end
end

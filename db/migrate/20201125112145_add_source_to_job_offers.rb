class AddSourceToJobOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :job_offers, :source, :string
    add_column :job_offers, :url, :string
  end
end

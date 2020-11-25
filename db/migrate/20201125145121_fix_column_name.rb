class FixColumnName < ActiveRecord::Migration[6.0]
  def change
     rename_column :job_offers, :url, :job_url
  end
end

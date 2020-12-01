class AddCategoryToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :category, :string
  end
end

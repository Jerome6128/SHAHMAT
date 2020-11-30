class RemoveUserIdFromCompetitors < ActiveRecord::Migration[6.0]
  def change
    remove_reference :competitors, :user, foreign_key: true
  end
end

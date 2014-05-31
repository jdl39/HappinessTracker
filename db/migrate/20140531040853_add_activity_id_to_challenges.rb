class AddActivityIdToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :activity_id, :integer
  end
end

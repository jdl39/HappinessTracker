class CreateHappinessResponses < ActiveRecord::Migration
  def change
    create_table :happiness_responses do |t|
      t.references :happiness_question, index: true
      t.float :value
      t.references :user, index: true

      t.timestamps
    end
  end
end

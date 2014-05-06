class CreateHappinessQuestions < ActiveRecord::Migration
  def change
    create_table :happiness_questions do |t|
      t.text :content
      t.integer :max_score

      t.timestamps
    end
  end
end

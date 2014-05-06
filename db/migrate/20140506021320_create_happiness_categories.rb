class CreateHappinessCategories < ActiveRecord::Migration
  def change
    create_table :happiness_categories do |t|
      t.string :name

      t.timestamps
    end

    create_table :happiness_categories_happiness_questions do |t|
    	t.belongs_to :happiness_category
    	t.belongs_to :happiness_question
    end
  end
end

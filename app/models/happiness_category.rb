class HappinessCategory < ActiveRecord::Base
	has_and_belongs_to_many :happiness_questions
end

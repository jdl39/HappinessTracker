class HappinessQuestion < ActiveRecord::Base
	has_and_belongs_to_many :happiness_categories
	has_many :happiness_responses

	def most_recent_response(user)
		return user.happiness_responses.order(created_at: :desc).take
	end
end

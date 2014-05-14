class HappinessQuestion < ActiveRecord::Base
	has_and_belongs_to_many :happiness_categories
	has_many :happiness_responses

	def most_recent_response(user)
		return self.most_recent_response_before(user, Time.now)
	end

	def most_recent_response_before(user, time)
		return HappinessResponse.where("happiness_question_id = ? AND user_id = ? AND created_at <= ?", self.id, user.id, time).order(created_at: :desc).take
	end

	def most_recent_score(user)
		return self.most_recent_score_before(user, Time.now)
	end

	def most_recent_score_before(user, time)
		response = self.most_recent_response_before(user, time)
		if response.nil?
			return nil
		end
		return response.value * 1.0 / self.max_score
	end

	def HappinessQuestion.question_with_most_stale_response(user)
		allQuestions = Array.new(HappinessQuestion.all)
		HappinessResponse.where("user_id = ?", user.id).order(created_at: :desc).find_each do |response|
			allQuestions.delete(response.happiness_question)
			if allQuestions.size == 1
				break
			end
		end
		return allQuestions[0]
	end
end

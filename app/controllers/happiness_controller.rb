class HappinessController < ApplicationController
	def post_happiness_response
		unless params[:question_id].nil? or params[:value].nil?
			hr = HappinessResponse.new
			hr.user = current_user
			hr.value = params[:value]
			hr.happiness_question = HappinessQuestion.find(params[:question_id])
			hr.save
		end
		render json: HappinessQuestion.question_with_most_stale_response(current_user)
	end

    def post_happiness_quiz
        params[:question].each do |q_id, value|
            hr = HappinessResponse.new
            hr.user = current_user
            hr.value = value
            hr.happiness_question = HappinessQuestion.find(q_id)
            hr.save
        end
        redirect_to action: 'index'
    end

    def get_happiness_scores
        num_days = params[:num_days]
        num_days = 14 if num_days.nil?
        happiness_values = []
        (0...num_days).each do |days_ago|
            hv = {}
            time = (num_days - days_ago - 1).days.ago
            hv[:value] = current_user.happiness_score_at_time(time)
            happiness_values << hv
        end

        render json: happiness_values
    end

    def index
        # Will need to have three different templates to route to based on if same user, friends, non_friends
    end

    def quiz
        @questions = []
        HappinessQuestion.all.each do |q|
            @questions << q.content
        end
    end
end

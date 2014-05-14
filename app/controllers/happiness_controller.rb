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

    def index
    end

    def quiz
        @questions = []
        HappinessQuestion.all.each do |q|
            @questions << q.content
        end
    end
end

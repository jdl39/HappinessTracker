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

    def index
    end
end

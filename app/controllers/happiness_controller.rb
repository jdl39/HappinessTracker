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

    def quiz
        @questions = [
            'I don\'t feel particularly pleased with the way I am. (X)', 
            'I am intensely interested in other people.', 
            'I feel that life is very rewarding',
            'I have very warm feelings towards almost everyone.',
            'I rarely wake up feeling rested. (X)',
            'I am not particularly optimistic abou thte future. (X)',
            'I find most things amusing.',
            'I am always committed and involved.',
            'Life is good.',
            'I don\'t think that the world is a good place. (X)',
            'I laugh a lot.',
            'I am well satisfied with everything in my life.',
            'I don\'t think I look attractive. (X)',
            'There is a gap between what I would like to do and what I have done. (X)',
            'I am very happy.',
            'I find beauty in some things.',
            'I have always had a cheerful effect on others.',
            'I can find time for everything I want to do.',
            'I feel that I am not especially in control of my life. (X)',
            'I feel able to take anything on.',
            'I feel fully mentally alert.',
            'I often experience joy and elation.',
            'I don\'t find it easy to make decisions. (X)',
            'I don\'t haev a particular sense of meaning and purpose in my life. (X)',
            'I feel I have a great deal of energy.',
            'I usually have a positive influence on events.',
            'I don\'t have fun with other people. (X)',
            'I don\'t feel particularly healthy. (X)',
            'I don\'t have particularly happy memories in the past. (X)'
        ]
    end
end

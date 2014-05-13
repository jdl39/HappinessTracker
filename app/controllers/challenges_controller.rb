class ChallengesController < ApplicationController
    def index
    end

	# Parameters User ID
	# Returns json array of accepted challenges
	def retrieve_accepted
       render text:''
    end

	# Parameters: User ID
	# Returns json array of failed challenges
	def retrieve_declined
       render text:''
    end

	# Parameters: Challenge ID
	# TODO: Validate that challenge is one that current user has received
    def accept
       render text: ''
    end

	# Parameters: Challenge ID
	# TODO: Validate that challenge is one that current user has received
	# TODO: Delete the request?
	def decline
	   render text: ''
	end

	# Parameters: None
	def new
       challenge = Challenge.new(:sender_id => params[:sender_id],
							 :receiver_id => params[:receiver_id],
							 :content => params[:content])
	   if challenge.save
           render json:challenge
	   else
		   render text:'-1'
	   end
	end

	# Parameters: challenge_id
	# Returns json of challenge
	def get_challenge
       render text:''
	end
end

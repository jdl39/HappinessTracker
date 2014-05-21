class ChallengesController < ApplicationController

	include ChallengesHelper

    def index
	   viewed_user = User.find_by_username(params[:username])
	   if (params[:username] == nil || is_current_user(viewed_user.username))
	      #Renders user's personal challenges page
		  @challenges = recently_sent_challenges(current_user.id)
		  @challenges += recently_received_challenges(current_user.id)
		  @challenges.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
		  render 'my_challenges'
	   elsif (are_friends(current_user.id, viewed_user.id))
		  #Renders friend-view of challenges page
		  @challenges = recently_sent_challenges(viewed_user.id)
		  @challenges += recently_received_challenges(viewed_user.id)
		  @challenges.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
		  render 'friend_challenges'
	   else
		  #Render non-friend-view
		  render 'non_friend_challenges'
	   end
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

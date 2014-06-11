class ChallengesController < ApplicationController

	include ChallengesHelper

	PENDING = 1
	ACCEPTED = 2
	DECLINED = 3
	COMPLETED = 4

    def index
	   viewed_user = User.find_by_username(params[:username])
	   if (params[:username] == nil || is_current_user(viewed_user.username))
	      #Renders user's personal challenges page
		  @pending_challenges = pending_challenges(current_user.id)
		  @pending_challenges.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
		  @active_challenges = active_challenges(current_user.id)
		  @active_challenges.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
		  @completed_challenges = completed_challenges(current_user.id)
		  @completed_challenges.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
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
       challenge = Challenge.find(params[:challenge_id])
       challenge.status = ACCEPTED
	   if challenge.save
	     render json:challenge
	   else
		 render text:'-1'
	   end
    end

	# Parameters: Challenge ID
	# TODO: Validate that challenge is one that current user has received
	# TODO: Delete the request?
	def decline
	   challenge = Challenge.find(params[:challenge_id])
	   challenge.status = DECLINED
	   if challenge.save
	     render json:challenge
	   else
		 render text:'-1'
	   end
	end

    # Parameters: Challenge ID
	# TODO: Validate that challenge is one that current user has received
	# TODO: Set challenges to true
	def complete
        challenge = Challenge.find(params[:challenge_id])
		challenge.status = COMPLETED
		if challenge.save
		  render json:challenge
		else
	      render text:'-1'
		end
	end	
	# Parameters: None
	def new
       challenge = Challenge.new(:sender_id => current_user.id,							 
								 :receiver_id => params[:receiver_id],
							     :activity_id => params[:activity_id],
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

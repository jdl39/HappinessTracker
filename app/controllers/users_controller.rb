class UsersController < ApplicationController
  include ChallengesHelper
  include FriendsHelper

  skip_before_action :require_login, only: [:index, :create]

  def index
    # see if there's an existing, user logged in
    if signed_in?
      redirect_to action: 'home'
    else
      @user = User.new
      render :layout => false
    end
  end

  def new
		@user = User.new
  end

  def login
    redirect_to action: 'home'
  end

#TODO: Remove
  def feed
	 viewed_user = User.find_by_username(params[:username]) 
	 if (is_current_user(viewed_user.username) || are_friends(current_user.id, viewed_user.id))
        #TODO: Set the logs 
     else
        #TODO: Render blank page
		render text: 'Permission denied'
     end
  end

  def profile
     @viewed_user = User.find_by_username(params[:username])
	      if (params[:username] == nil || is_current_user(@viewed_user.username))
		      # Render user's personal profile page
			  @newsfeed_hashes = gather_newsfeed_entries(current_user.id)
			  render 'my_profile' 
		  elsif (are_friends(current_user.id, @viewed_user.id))
			  # Show friend-permissable view
			  @newsfeed_hashes = gather_newsfeed_entries(@viewed_user.id)
			  render 'friend_profile'
		  else
			  # Render non-friend page
          @newsfeed_hashes = gather_newsfeed_entries(@viewed_user.id)
		      @friend_request_exists = friend_request_exists(current_user.id, @viewed_user.id)
			  render 'non_friend_profile'
	      end
  end

  def gather_newsfeed_entries(user_id)
    newsfeed_hashes = recently_sent_challenges(user_id)
	newsfeed_hashes += recently_received_challenges(user_id)
	newsfeed_hashes += recent_friendships(user_id)
    newsfeed_hashes.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
	return newsfeed_hashes
  end

#TODO: this activities function needs to be moved to activities controller
  def activities
	 viewed_user = User.find_by_username(params[:username])
	 if (is_current_user(viewed_user.username))
         #TODO: Redirect to user's personal activities page	
	 elsif (are_friends(current_user.id, viewed_user.id))
		 # Show friend-permissable view
		 @activity_types = []
		 activities = Activity.where(user_id:viewed_user.id)
		 activities.each do |activity|
            @activity_types << ActivityType.where(id:activity.activity_type_id)
	     end
     else
	     #TODO: Render blank page
		 render text:'Permission denied'
	 end 
  end

  def home
    @user = current_user
	#TODO: Set these recommended_activities
	@recommended_activities = ['Running', 'Jogging', 'Swimming', 'Hiking']
    # Set recent challenges received by user
	@my_received_challenges = recently_received_challenges(current_user.id) 
  end

  def create
      # names of fields:
      # firstname
      # lastname
      # username
      # password
    @user = User.new(user_params)
    if @user.valid? && @user.save
      sign_in @user
      redirect_to action: 'home'
    else
      p @user.errors.messages
      flash.now[:error] = @user.errors.messages
      render 'index', :layout => false
    end
  end

  def set_happy_status
	  current_user.is_happy = params[:is_happy]
	  if current_user.save
		  render text: current_user.id
	  else
		  render text: '-1'
      end
  end

  private
    	def user_params
     		return params.require(:user).permit(:first_name, :last_name, :username, :email, :password,
                                   :password_confirmation)
    	end

		def require_login
			unless signed_in?
				redirect_to action: 'index'
			end
	    end

		def settings
        end
  end

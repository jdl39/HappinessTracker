class UsersController < ApplicationController
before_action :require_login, :except=>[:index, :create]

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

  def feed
	 viewed_user = User.find_by_username(params[:username]) 
	 if (is_current_user(viewed_user.username) || are_friends(current_user.id, viewed_user.id))
        #TODO: Set the logs 
     else
        #TODO: Render blank page
		render text: 'Permission denied'
     end
  end

  
  def challenges
	 viewed_user = User.where(params[:username]) 
	 if (!is_current_user(viewed_user.username))
		 #TODO: Redirect to user's personal challenges page
	 elsif (are_friends(current_user.id, viewed_user.id))
	     #Renders friend-view of challenges page
		 @challenges = Challenge.where(sender_id:current_user.id, receiver_id:viewed_user.id)
		 @challenges += Challenge.where(sender_id:viewed_user.id, receiver_id:current_user.id)
		 @challenges.sort! {|a,b| a.created_at <=> b.created_at }
     else
	     #TODO: Render blank page
	     render text: 'Permission denied'
	 end	 
  end

  def messages
	viewed_user = User.find_by_username(params[:username]) 
    if (is_current_user(viewed_user.username))
		 #TODO: Redirect to user's personal messages page
	elsif (are_friends(current_user.id, viewed_user.id))
		 # Renders friend-view of messages page
	     @messages = Message.where(sender_id:current_user.id, receiver_id:friend.id)
		 @messages += Message.where(sender_id:friend.id, receiver_id:current_user.id)
	     @messages.sort! {|a,b| a.created_at <=> b.created_at }
    else
	     #TODO: Render blank page
		 render text: 'Permission denied'
	end
  end

  def friends
     viewed_user = User.find_by_username(params[:username])
	 if (is_current_user(viewed_user.username)) 
	     #TODO: Redirect to user's personal activities page 	
	 elsif (are_friends(current_user.id, viewed_user.id))
		 # Show friend-view of friends page
	     @friends = Friend.where(user_id:viewed_user.id)
	     @friends += Friend.where(friend_id:viewed_user.id)
	 else
	     #TODO: Render blank page
		 render text:'Permission denied'
	 end
  end

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
    # Render landing page
  end

  def create
      # names of fields:
      # firstname
      # lastname
      # username
      # password
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to action: 'home'
    else
      render 'index'
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

		def are_friends(user_id_1, user_id_2)
            (!Friend.where(user_id:user_id_1, friend_id:user_id_2).blank? ||
	        !Friend.where(user_id:user_id_2, friend_id:user_id_1).blank?)			
		end

		def is_current_user(username)
            username == current_user.username
		end	

		def settings
        end
  end

class UsersController < ApplicationController
before_action :require_login, :except=>[:index, :create]

  def index
    # see if there's an existing, user logged in
    if signed_in?
      redirect_to action: 'home'
    else
      @user = User.new
    end
  end

	def new
		@user = User.new
	end

  def login
    redirect_to action: 'home'
  end

  # TODO: Check if friends or if user
  def feed
     @user = current_user
	 if (params[:username] == @user.username)

     else
     end
  end

  def challenges
     @user = current_user
	 if (params[:username] == @user.username)
     
	 else
	 end 
  end

  def messages
     @user = current_user
	 if (params[:username] == @user.username)

	 else
	 end 
  end

  def friends
     @user = current_user
	 if (params[:username] == @user.username)
         @friends = Friend.where(:user_id=>@user.id)
		 @friends << Friend.where(:friend_id=>@user.id)
	 else
     end 
  end

  def activities
     @user = current_user
	 if (params[:username] == @user.username)

	 else
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

end

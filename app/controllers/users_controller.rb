class UsersController < ApplicationController
before_action :require_login, :except=>[:index]

  def index
    # see if there's an existing, user logged in
    if signed_in?
      redirect_to action: 'home'
    else
      @user = User.new
    end
  end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

  def login
    redirect_to :action => 'show'
  end

  def profile
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
      redirect_to @user
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

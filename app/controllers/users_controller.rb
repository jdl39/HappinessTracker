class UsersController < ApplicationController

  def index
    # see if there's an existing, user logged in
    @user = User.new
  end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
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
end

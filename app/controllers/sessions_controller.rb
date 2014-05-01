class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(username: params[:session][:username])
		if (user && user.authenticate(params[:session][:password]))
			sign_in user
		else
			flash.now[:error] = "Invalid username/password."
		end
		redirect_to controller: 'users', action: 'index'
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end

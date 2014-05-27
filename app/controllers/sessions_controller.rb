class SessionsController < ApplicationController
	skip_before_action :require_login, only: :create

	def new
	end

	def create
        user = User.from_omniauth(env["omniauth.auth"]) if env["omniauth.auth"]
        if user
            sign_in user
        else
            user = User.find_by(username: params[:session][:username]) if user.nil?
            if (user && user.authenticate(params[:session][:password]))
                sign_in user
            else
                flash.now[:error] = "Invalid username/password."
            end
        end
        redirect_to controller: 'users', action: 'index'
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end

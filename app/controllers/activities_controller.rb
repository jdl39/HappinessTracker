class ActivitiesController < ApplicationController
    before_action :set_activity, only: [:show, :edit, :update, :destroy]

	def show
    end

	# GET /activities/new
	def new
        @activity = Activity.new
    end

	# POST /users
	# POST /users.json
	def create
       @activity = Activity.new(activity_params)

       respond_to do |format|
	      if @activity.save
	         format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
		     format.json { render action: 'show', status: :created, location: @activity }
	      else
			 format.html { render action: 'new' }
			 format.json { render json: @activity.errors, status: :unprocessable_entity }
		  end
       end
    end

	# PATCH/PUT /users/1
	# PATCH/PUT /users/1.json
	def update
        respond_to do |format|
	        if @activity.update(user_params)
		        format.html { redirect_to @activity, notice: 'User was successfully updated.' }
			    format.json { head :no_content }
	        else
			    format.html { render action: 'edit' }
			    format.json { render json: @activity.errors, status: :unprocessable_entity }
		    end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
        @user.destroy
	    respond_to do |format|
		    format.html { redirect_to users_url }
			format.json { head :no_content }
		end
    end


	private
       # Use callbacks to share common setup or constraints between actions.	   
       def set_activity
		   @activity = Activity.find(params[:id])
	   end

	   # Restrict parameters
	   def activity_params
		   #params.require(:activity).permit(Fill in)
	   end
end

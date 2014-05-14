class MessagesController < ApplicationController
    # Returns all messages associated with user id
	# TODO: Check to see that user id corresponds to current user
	def inbox
       messages = Message.where(sender_id: params[:user_id])
	   messages << Message.where(receiver_id: params[:user_id])
	   render json:messages 
    end

	# Creates a new message
	# TODO: Check that sender id corresponds to current user
	def new
       message = Message.new(:sender_id => params[:sender_id],
							 :receiver_id => params[:receiver_id],
							 :content => params[:content])
       if message.save
           render json:message
	   else
           render text:'-1'
	   end	   
	end

    # TODO: NEED TO HAVE A METHOD FOR THE INBOX THAT WILL RENDER A TEMPLATE, NOT JSON


end

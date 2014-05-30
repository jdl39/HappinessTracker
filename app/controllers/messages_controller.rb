class MessagesController < ApplicationController

	include MessagesHelper

    # Renders page based on whether user/friend/non-friend
	def inbox
       viewed_user = User.find_by_username(params[:username]) 
	      if (params[:username] == nil || is_current_user(viewed_user.username))
			  @message_items = recently_sent_messages(current_user.id)
			  @message_items += recently_received_messages(current_user.id)
			  @message_items.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
			  #Render personal view of inbox
			  render 'my_inbox'
		  elsif (are_friends(current_user.id, viewed_user.id))
			  # TODO: Renders friend-view of messages page
			  @messages = Message.where(sender_id:current_user.id, receiver_id:friend.id)
			  @messages += Message.where(sender_id:friend.id, receiver_id:current_user.id)
			  render 'friend_inbox'
		  else
			  #Render non-friend-view
			  render 'non_friend_inbox'
		  end  
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

    # TODO: need some sort of reporting function for abusive messages
end

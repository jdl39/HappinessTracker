class MessagesController < ApplicationController

	include MessagesHelper

    # @Jimmy: I don't know what the purpose of friend_inbox and not_friend_inbox are. However, if you still want them, I left your original inbox method in old_method

    # Renders page based on whether user/friend/non-friend
	def inbox
        messages = recently_sent_messages(current_user.id)
        messages += recently_received_messages(current_user.id)
		messages = messages.uniq
		pairs = []
		@message_items = []
		messages.each do |message|
          pair = {:sender => message[:sender_sig], :receiver => message[:receiver_sig]}
          reverse_pair = {:sender => message[:receiver_sig], :receiver => message[:sender_sig]}
		  if (!pairs.include?(pair) && !pairs.include?(reverse_pair))
			  pairs << pair
			  pairs << reverse_pair
			  @message_items << message
		  end
		end
	    @message_items.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
        render 'my_inbox'
	end

    def show
	   if (params[:username] != nil)	
          @viewed_user = User.find_by_username(params[:username])
		  if (@viewed_user == current_user)
			 redirect_to '/inbox'
		  else 
			 @messages = Message.where(sender_id:current_user.id, receiver_id:@viewed_user.id)
			 @messages += Message.where(sender_id:@viewed_user.id, receiver_id:current_user.id)
	         @messages.sort! {|a,b| b.created_at <=> a.created_at }
			 render 'friend_inbox'
		  end
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

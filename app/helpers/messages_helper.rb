module MessagesHelper

  # Recently sent challenges
  def recently_sent_messages(user_id)
	messages = Message.where(sender_id:user_id)
	reduced_messages = []
	found_ids = []
	messages.each do |message|
      if (!found_ids.include?(message.receiver_id))
	    found_ids << message.receiver_id
	    reduced_messages << message	
	  end
	end
	return populate_messages(reduced_messages)
  end

  # Recently received challenges
  def recently_received_messages(user_id)
	messages = Message.where(receiver_id:user_id)
	reduced_messages = []
	found_ids = []
	messages.each do |message|
      if (not found_ids.include?(message.sender_id))
	    found_ids << message.sender_id
	    reduced_messages << message	
	  end
	end
	return populate_messages(reduced_messages)
  end 

  def get_shared_messages(user_1_id, user_2_id)
    messages = Message.where(sender_id:user_1_id, receiver_id:user_2_id)
	messages += Message.where(receiver_id:user_1_id, sender_id:user_2_id)
	return populate_messages(messages)
  end


  def recent_threads(user_id)
    messages = recently_sent_messages(user_id)
	messages += recently_received_messages(user_id)
	messages = messages.uniq
	messages.sort! {|a,b| b[:timestamp] <=> a[:timestamp] }
	pairs = []
	message_items = []
	messages.each do |message|
	  pair = {:sender => message[:sender_sig], :receiver => message[:receiver_sig]}
	  reverse_pair = {:sender => message[:receiver_sig], :receiver => message[:sender_sig]}
	  if (!pairs.include?(pair) && !pairs.include?(reverse_pair))
	    pairs << pair
	    pairs << reverse_pair
	    message_items << message
	  end
	end
    return message_items	
  end 

  # Populates the messages
  def populate_messages(messages)
	results = []
	messages.each do |message|
	  sender = User.find(message.sender_id) 
	  receiver = User.find(message.receiver_id)
      if Friend.exists?(user_id:sender.id, friend_id:receiver.id, accepted:true) || Friend.exists?(user_id:receiver.id, friend_id:sender.id, accepted:true)
          sender_sig = sender.username
          receiver_sig = receiver.username
      else
          sender_sig = message.sender_sig
          receiver_sig = message.receiver_sig
      end
	  result = {:sender_sig => sender_sig, 
                :receiver_sig => receiver_sig,
				:content => message.content,
                :quote => message.quote,
				:type => 'message',
				:timestamp => message.created_at
			   }   
	  results << result
	end 
	return results
  end 

end

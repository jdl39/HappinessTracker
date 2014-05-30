module MessagesHelper

  # Recently sent challenges
  def recently_sent_messages(user_id)
	messages = Message.where(sender_id:user_id).recent
	return populate_messages(messages)
  end

  # Recently received challenges
  def recently_received_messages(user_id)
	messages = Message.where(receiver_id:user_id).recent
	return populate_messages(messages)
  end 

  # Populates the messages
  def populate_messages(messages)
	results = []
	messages.each do |message|
	  sender = User.find(message.sender_id) 
	  receiver = User.find(message.receiver_id)
	  result = {:sender => sender, 
				:receiver => receiver, 
				:message => message, 
				:type => 'message',
				:timestamp => message.created_at
			   }   
	  results << result
	end 
	return results
  end 

end

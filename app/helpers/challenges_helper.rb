module ChallengesHelper

  # Recently sent challenges
  def recently_sent_challenges(user_id)
    challenges = Challenge.where(sender_id:user_id).recent
    return populate_challenges(challenges)
  end

  # Recently received challenges
  def recently_received_challenges(user_id)
    challenges = Challenge.where(receiver_id:user_id).recent
    return populate_challenges(challenges)
  end

  def active_challenges(user_id)
    challenges = Challenge.where(receiver_id:user_id, status:2)
	return populate_challenges(challenges)
  end

  def pending_challenges(user_id)
	challenges = Challenge.where(receiver_id:user_id, status:1)
	return populate_challenges(challenges)
  end

  def completed_challenges(user_id)
	challenges = Challenge.where(receiver_id:user_id, status:4)
	return populate_challenges(challenges)
  end

  # Populates the challenges
  def populate_challenges(challenges)
    results = []
	challenges.each do |challenge|
      sender = User.find(challenge.sender_id) 
	  receiver = User.find(challenge.receiver_id)
	  if (challenge.activity_id != nil)
	    activity = Activity.find(challenge.activity_id)
	    activity_type = ActivityType.find(activity.activity_type_id)
	  else
		 activity = nil
		 activity_type = nil
	  end 
	  result = {:sender => sender, 
		        :receiver => receiver, 
				:challenge =>challenge,
			    :activity =>activity,
			    :activity_type => activity_type,	
				:type => 'challenge',
	  			:timestamp => challenge.created_at
	  }
	  results << result
	end 
	return results
  end
end

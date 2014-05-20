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

  # Populates the challenges
  def populate_challenges(challenges)
    results = []
	challenges.each do |challenge|
      sender = User.find(challenge.sender_id) 
	  receiver = User.find(challenge.receiver_id)
	  result = {:sender => sender, :receiver => receiver, :challenge =>challenge, :type => 'challenge'}
	  results << result
	end 
	return results
  end
end

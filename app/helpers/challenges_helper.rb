module ChallengesHelper

  # Recent challenges
  def recent_challenges(user_id)
    return Challenge.where(user_id:user_id).recent
  end
end

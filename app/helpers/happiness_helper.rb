module HappinessHelper

  def recent_happiness_responses(user_id)
    return HappinessResult.where(user_id:user_id).recent
  end
end

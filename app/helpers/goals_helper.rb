module GoalsHelper

  def recent_goals
    return Goal.where(user_id:user_id).recent
  end
end

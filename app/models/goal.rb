class Goal < ActiveRecord::Base
  belongs_to :goal_type
  belongs_to :activity
  has_many :goal_completions

  def next_time_due
  	days_since_creation = (Time.now - self.created_at).to_i / (60 * 60 * 24)
  	return self.created_at + self.goal_type.days_to_complete.days * ((days_since_creation / self.goal_type.days_to_complete) + 1)
  end
end

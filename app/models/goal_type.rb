class GoalType < ActiveRecord::Base
  belongs_to :guide
  belongs_to :activity_type
  belongs_to :measurement_type
  has_many :goals

  def GoalType.goal_type_for(activity_type, measurement_type, is_repeated, requires_greater, measurement_value, days_to_complete)
  	to_return = GoalType.find_by(activity_type: activity_type, measurement_type: measurement_type, is_repeated: is_repeated, requires_greater: requires_greater, measurement_value: measurement_value, days_to_complete: days_to_complete, guide: nil)
  	if to_return.nil?
  		to_return = GoalType.new
  		to_return.activity_type = activity_type
  		to_return.measurement_type = measurement_type
  		to_return.is_repeated = is_repeated
  		to_return.requires_greater = requires_greater
  		to_return.measurement_value = measurement_value
  		to_return.days_to_complete = days_to_complete
  		to_return.guide = nil
  		to_return.save
  	end
  	return to_return
  end
end

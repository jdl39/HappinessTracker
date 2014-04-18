class ActivityType < ActiveRecord::Base
	has_many :activities
	has_many :goal_types
end

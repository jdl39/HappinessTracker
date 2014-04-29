class ActivityType < ActiveRecord::Base
	validates :name, presence: true
	has_many :activities
	has_many :goal_types
end

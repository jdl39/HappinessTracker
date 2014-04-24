class ActivityType < ActiveRecord::Base
    before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 20 }
	has_many :activities
	has_many :goal_types
end

class Guide < ActiveRecord::Base
	has_many :goal_types

    scope :recent, -> { order('created_at desc').limit(4) }
end

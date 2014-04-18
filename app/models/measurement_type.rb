class MeasurementType < ActiveRecord::Base
	has_many :goal_types
	has_many :measurements
	has_and_belongs_to_many :activities
end

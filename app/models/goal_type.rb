class GoalType < ActiveRecord::Base
  belongs_to :guide
  belongs_to :activity_type
  belongs_to :measurement_type
  has_many :goals
end

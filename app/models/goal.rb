class Goal < ActiveRecord::Base
  belongs_to :goal_type
  belongs_to :activity
end

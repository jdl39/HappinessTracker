class Goal < ActiveRecord::Base
  belongs_to :goal_type
  belongs_to :activity

  scope :recent, -> { order('created_at desc').limit(4) }
end

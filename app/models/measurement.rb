class Measurement < ActiveRecord::Base
  belongs_to :measurement_type
  belongs_to :measurement_note
  belongs_to :activity

  # This checks to see if the new measurement satisfies any goals. 
  # NOTE: It assumes goals are up to date!
  after_create do |measurement|
  	measurement.check_all_goals_for_completion
  end

  scope :recent, -> { order('created_at desc').limit(4) }

  def check_all_goals_for_completion
    possible_goals = Goal.where("activity_id = ? AND active = ?", self.activity_id, true)
    possible_goals.each do |goal|
      goal.check_for_completion(self)
    end
  end

  def date_string
    self.created_at.strftime('%a %h %d %G')
  end
end

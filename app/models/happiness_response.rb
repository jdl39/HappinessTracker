class HappinessResponse < ActiveRecord::Base
  belongs_to :happiness_question
  belongs_to :user

  scope :recent, -> { order('created_at desc').limit(4) }
end

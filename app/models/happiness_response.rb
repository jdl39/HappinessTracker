class HappinessResponse < ActiveRecord::Base
  belongs_to :happiness_question
  belongs_to :user
end

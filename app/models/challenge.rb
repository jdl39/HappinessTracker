class Challenge < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :challenge
  scope :recent, -> { order('created_at desc').limit(4) }
end

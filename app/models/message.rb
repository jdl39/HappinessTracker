class Message < ActiveRecord::Base
   belongs_to :sender, class_name: "User"
   belongs_to :receiver, class_name: "User"

   scope :recent, -> { order('created_at desc').limit(4) }

   validates :sender, presence: true
   validates :receiver, presence: true
end

class Friend < ActiveRecord::Base
    belongs_to :user
    belongs_to :friend, class_name: "User"
    scope :recent, -> { order('created_at desc').limit(4) }
end

class Friendship < ActiveRecord::Base
    belongs_to :first, class_name: "User"
	belongs_to :second, class_name: "User"
end

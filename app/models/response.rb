class Response < ActiveRecord::Base
  belongs_to :comment
  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :reader, class_name: "User"
  has_and_belongs_to_many :down_voter, class_name: "User"
  has_and_belongs_to_many :up_voter, class_name: "User"
end

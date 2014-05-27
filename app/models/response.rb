class Response < ActiveRecord::Base
  belongs_to :comment
  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :readers, class_name: "User", :join_table => :response_readers
  has_and_belongs_to_many :down_voters, class_name: "User", :join_table => :response_up_voters
  has_and_belongs_to_many :up_voters, class_name: "User", :join_table => :response_down_voters

  scope :recent, -> { order('created_at desc').limit(4) }
end

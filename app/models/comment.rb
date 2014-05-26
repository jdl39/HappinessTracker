class Comment < ActiveRecord::Base
  belongs_to :activity_type
  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :readers, class_name: "User", :join_table => :comment_readers
  has_and_belongs_to_many :down_voters, class_name: "User", :join_table => :comment_up_voters
  has_and_belongs_to_many :up_voters, class_name: "User", :join_table => :comment_down_voters
  has_many :response
end

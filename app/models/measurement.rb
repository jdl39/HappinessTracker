class Measurement < ActiveRecord::Base
  belongs_to :measurement_type
  belongs_to :measurement_note
  belongs_to :activity

  scope :recent, -> { order('created_at desc').limit(4) }
end

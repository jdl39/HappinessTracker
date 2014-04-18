class Measurement < ActiveRecord::Base
  belongs_to :measurement_type
  belongs_to :measurement_note
  belongs_to :activity
end

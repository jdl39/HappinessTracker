class CreateMeasurementNotes < ActiveRecord::Migration
  def change
    create_table :measurement_notes do |t|
      t.text :contents

      t.timestamps
    end
  end
end

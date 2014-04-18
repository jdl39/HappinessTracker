class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.references :measurement_type, index: true
      t.references :measurement_note, index: true
      t.references :activity, index: true
      t.float :value

      t.timestamps
    end
  end
end

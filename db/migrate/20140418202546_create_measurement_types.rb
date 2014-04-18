class CreateMeasurementTypes < ActiveRecord::Migration
  def change
    create_table :measurement_types do |t|
      t.boolean :is_quantifiable
      t.string :name

      t.timestamps
    end
  end
end

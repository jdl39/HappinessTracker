class CreateMeasurementTypes < ActiveRecord::Migration
  def change
    create_table :measurement_types do |t|
      t.boolean :is_quantifiable
      t.string :name

      t.timestamps
    end

    create_table :activities_measurement_types, id: false do |t|
      t.belongs_to :activity
      t.belongs_to :measurement_type
    end
  end
end

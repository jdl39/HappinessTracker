class CreateActivityWords < ActiveRecord::Migration
  def change
    create_table :activity_words do |t|
          t.references :activity_type, index: true
          t.string :word, index: true

      t.timestamps
    end
  end
end

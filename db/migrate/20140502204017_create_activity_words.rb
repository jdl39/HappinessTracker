class CreateActivityWords < ActiveRecord::Migration
  def change
    create_table :activity_words do |t|
          t.references :activity_type, index: true
          t.text :word

      t.timestamps
    end
  end
end

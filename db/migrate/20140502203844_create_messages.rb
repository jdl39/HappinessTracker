class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
	  t.references :sender, references: :users, index: true
	  t.references :receiver, references: :users, index: true
	  t.text :content

      t.timestamps
    end
  end
end

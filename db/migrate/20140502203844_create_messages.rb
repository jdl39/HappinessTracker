class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
	  t.references :sender, references: :users, index: true
	  t.references :receiver, references: :users, index: true
	  t.text :content
          t.text :sender_sig
          t.text :receiver_sig

      t.timestamps
    end
  end
end

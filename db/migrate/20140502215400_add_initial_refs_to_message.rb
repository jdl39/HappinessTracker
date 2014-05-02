class AddInitialRefsToMessage < ActiveRecord::Migration
  def change
	  add_reference :messages, :sender, references: :users, index: true
	  add_reference :messages, :receiver, references: :users, index: true
	  add_reference :messages, :challenge, index: true
  end
end

class AlterMessagesReferences < ActiveRecord::Migration[6.1]
  def change
    change_table :messages do |t|
      t.remove_references :sender
      t.references :sender, references: :chat_participants, null: false, foreign_key: { to_table: :chat_participants}
    end
  end
end

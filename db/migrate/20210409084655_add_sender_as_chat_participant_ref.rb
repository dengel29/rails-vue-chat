class AddSenderAsChatParticipantRef < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :sender, references: :chat_participants, null: false, foreign_key: { to_table: :chat_participants}
  end
end

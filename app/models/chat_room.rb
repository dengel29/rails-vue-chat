class ChatRoom < ApplicationRecord
  has_many :chat_participants
  has_many :messages
end

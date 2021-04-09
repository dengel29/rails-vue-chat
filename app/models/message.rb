class Message < ApplicationRecord
  belongs_to :chat_participant
  belongs_to :chat_room

  def sender 
    chat_participant
  end

  def sender=(cp)
    self.chat_participant = cp
  end
end

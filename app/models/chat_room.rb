class ChatRoom < ApplicationRecord
  has_many :chat_participants
  has_many :messages
  has_many :users, through: :chat_participants

  def self.find_or_create_by_host_and_invited(host_id, invited_id)
    # create new chatroom with current user, target user
    puts
    existing_chat_room = User.find(host_id).chat_rooms.includes(:users).where(users: {id: invited_id})[0]
    
    if existing_chat_room
      return existing_chat_room
    else
      new_chat_room = ChatRoom.create!
      ChatParticipant.create!(user: User.find(host_id), chat_room: new_chat_room)
      ChatParticipant.create!(user: User.find(invited_id), chat_room: new_chat_room)
      return new_chat_room 
    end
  end

  def send_chatroom(chatroom, chatroom_hash, chatroom_info)
    NotificationsChannel.broadcast_to(chatroom.users.first, chatroom_info)
    
    ChatChannel.broadcast_to(chatroom, { 
      "chatroom" => chatroom_hash, 
      "users" => chatroom_hash["users"], 
      "type" => "chatroom_receipt"
    })
  end

  def send_message(chatroom, message)
    message_type = {
      "type" => "message_receipt"
    }
    m = message.as_json.merge(message_type)
    ChatChannel.broadcast_to(chatroom, m)
  end
end

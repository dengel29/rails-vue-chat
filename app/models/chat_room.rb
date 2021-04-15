class ChatRoom < ApplicationRecord
  has_many :chat_participants
  has_many :users, through: :chat_participants
  has_many :messages

  def self.find_or_create_by_host_and_invited(host_id, invited_id)
    # create new chatroom with current user, target user
    existing_chat_room = User.find(host_id).chat_rooms.includes(:users).where(users: {id: invited_id})[0]
    
    puts existing_chat_room.users.count
    if existing_chat_room
      return existing_chat_room
    else
      new_chat_room = ChatRoom.create!
      ChatParticipant.create!(user: User.find(host_id), chat_room: new_chat_room)
      ChatParticipant.create!(user: User.find(invited_id), chat_room: new_chat_room)
      return new_chat_room 
    end
  end

  def send_chatroom(chatroom)
    users = chatroom.users
    NotificationsChannel.broadcast_to(users.first, {message: "you've been invited to a chatroom"})
    ChatChannel.broadcast_to(chatroom, { chat_room: chatroom, users: users })
  end
end

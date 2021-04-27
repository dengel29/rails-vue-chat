class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # has_many :chat_rooms, through: :chat_participants
  has_many :chat_participants
  has_many :messages, through: :chat_participants
  has_many :chat_rooms, through: :chat_participants

  def appear(user)
    ActionCable.server.broadcast("user_list", { user: user, online: true })
  end

  def disappear(user) 
    ActionCable.server.broadcast("user_list", { user: user, online: false })
  end

  def find_or_create_by_invited(invited_id)
    existing_chat_room = @user.chat_rooms.includes(:users).where(users: {id: invited_id})[0]
    
    if existing_chat_room
      return existing_chat_room
    else
      new_chat_room = ChatRoom.create!
      ChatParticipant.create!(user: @user, chat_room: new_chat_room)
      ChatParticipant.create!(user: User.find(invited_id), chat_room: new_chat_room)
      return new_chat_room
    end
  end
end

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
end

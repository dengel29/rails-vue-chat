class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def appear(user)
    ActionCable.server.broadcast("all_users", { body: "#{user.username} is now online" })
  end

  def disappear(user) 
    ActionCable.server.broadcast("all_users", { body: "#{user.username} has logged off" })
  end
end

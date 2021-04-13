class UserListChannel < ApplicationCable::Channel
  def subscribed
    current_user.appear(current_user)
    stream_from 'user_list'
  end

  def unsubscribed
    current_user.disappear(current_user)
  end

  def appear(data)
    current_user.appear(on: data['appearing_on'])
  end

  def send_invitation(data)
    puts "invitation sent from #{data['host_id']} to #{data['target_user_id']}"
    
    # if we can't find an existing chatroom with these 2 users...
    # ChatRoom.where chat_participants.includes(id: host_id && id: target_user_id )
    
    host = current_user
    invited_user = User.find(data['target_user_id'])
    # create new chatroom with current user, target user
    
    existing_chat_room = User.find(host.id).chat_rooms.includes(:users).where(users: {id: invited_user.id})[0]

    if existing_chat_room
      existing_chat_room
      puts "entered chat room id: #{existing_chat_room.id}"
    else
      new_chat_room = ChatRoom.create!
      ChatParticipant.create!(user: host, chat_room: new_chat_room)
      ChatParticipant.create!(user: invited_user, chat_room: new_chat_room)
      puts "created and entered new chat room id: #{new_chat_room.id}"
    end
    

  end

  def away
    current_user.away
  end
end

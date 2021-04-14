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
    
    chatroom = ChatRoom.find_or_create_by_host_and_invited(data['host_id'], data['target_user_id'])
    

  end

  def away
    current_user.away
  end
end

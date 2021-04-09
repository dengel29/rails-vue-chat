class UserListChannel < ApplicationCable::Channel
  def subscribed
    current_user.appear(current_user) 
  end

  def unsubscribed
    current_user.disappear(current_user)
  end

  def appear(data)
    current_user.appear(on: data['appearing_on'])
  end

  def send_invitation(data)
    # create chatroom with current user, target user
    puts data
    puts "invitation sent from #{data['host_id']} to #{data['target_user_id']}"
    # build_chat(data[''])
    # ChatRoom.new()
  end

  def away
    current_user.away
  end
end

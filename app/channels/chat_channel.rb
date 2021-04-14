class ChatChannel < ApplicationCable::Channel
  def subscribed
    chatroom = ChatRoom.find_or_create_by_host_and_invited(params['host_id'], params['target_user_id'])
    puts "#{User.find(params['host_id'])} subscribed to chatroom"
    puts chatroom.id
    stream_for chatroom
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

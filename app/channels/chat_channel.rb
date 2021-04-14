class ChatChannel < ApplicationCable::Channel
  after_subscribe :send_chat_room_id
  def subscribed
    @chatroom = ChatRoom.find_or_create_by_host_and_invited(params['host_id'], params['target_user_id'])
    puts "#{User.find(params['host_id'])} subscribed to chatroom"
    stream_for @chatroom
  end

  def send_message
    # create message with :content, :sender_id, chat_room_id
  end

  def send_chat_room_id
    ActionCable.server.broadcast(current_user, { chat_room_id: @chatroom.id })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

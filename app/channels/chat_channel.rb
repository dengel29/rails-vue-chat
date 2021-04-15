class ChatChannel < ApplicationCable::Channel
  # after_subscribe :send_chat_room_id
  def subscribed
    
    stream_for chatroom
  end

  def send_message
    # create message with :content, :sender_id, chat_room_id
  end

  def get_chat_room
    cr = chatroom
    message_type = { "type" => "chatroom_info" }
    users = { "users" => cr.users.as_json }

    inviter = { "host" => User.find(params["host_id"]).as_json }
    chatroom_hash = {}.merge(users, message_type, inviter)
    puts "sending chatroom id [channel]"
    cr.send_chatroom(cr, chatroom_hash)
    # ActionCable.server.broadcast("user_list", { user: user, online: true })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private 

  def chatroom
    ChatRoom.find_or_create_by_host_and_invited(params['host_id'], params['target_user_id'])
  end

  def subscribe_others
  
  end
end

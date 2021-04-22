class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for chatroom
  end

  def create_message(data)
    # create message with :content, :sender_id, chatroom_id
    chatroom = ChatRoom.find(data["chatroom_id"])
    message = Message.new(
      content: data["message"], 
      chat_room: chatroom, 
      chat_participant: ChatParticipant.find(data["sender_id"])
    )
    if message.save!
      chatroom.send_message(chatroom, message)
    end
  end

  def get_chatroom
    cr = chatroom
    combined_users = cr.users.as_json 
    combined_users = combined_users << User.find(params["host_id"]).as_json
    type = { "type" => "chatroom_info" }
    users = { "users" => combined_users }
    ch = cr.as_json
    messages = {"messages" => chatroom.messages.as_json}
    chatroom_info = {}.merge(users, type, ch)
    chatroom_hash = chatroom_info.merge(messages)
    
    cr.send_chatroom(cr, chatroom_hash, chatroom_info)
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

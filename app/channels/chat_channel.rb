class ChatChannel < ApplicationCable::Channel
  after_subscribe :get_chatroom

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
    messages = {"messages" => chatroom.messages.as_json}
    ch = cr.as_json
    chatroom_info = {}.merge(users, type, ch)
    chatroom_hash = chatroom_info.merge(messages)
    
    cr.send_chatroom(cr, chatroom_hash, chatroom_info)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private 

  def chatroom
    existing_chat_room = current_user.chat_rooms.includes(:users).where(users: {id: params["target_user_id"]})[0]
    
    if existing_chat_room
      return existing_chat_room
    else
      new_chat_room = ChatRoom.create!
      ChatParticipant.create!(user: current_user, chat_room: new_chat_room)
      ChatParticipant.create!(user: User.find(params["target_user_id"]), chat_room: new_chat_room)
      return new_chat_room
    end
  end

  def subscribe_others
  
  end
end

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

  def away
    current_user.away
  end
end

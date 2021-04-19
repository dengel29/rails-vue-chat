class ChatsController < ApplicationController
  def index
    @users = User.all
  end

  def show 
    ChatRoom.find(params[:id]).messages
  end
end

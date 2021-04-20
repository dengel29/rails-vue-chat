class ChatsController < ApplicationController
before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.all
  end

  def show 
    ChatRoom.find(params[:id]).messages
  end
end

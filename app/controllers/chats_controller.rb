class ChatsController < ApplicationController
before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.all.filter do |user|
      user != current_user
    end

    @user = current_user
    puts current_user
  end

  def show 
    ChatRoom.find(params[:id]).messages
  end
end

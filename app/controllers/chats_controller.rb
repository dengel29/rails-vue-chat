class ChatsController < ApplicationController
  def index
    @users = User.all
  end
end

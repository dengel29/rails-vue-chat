module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private
    def find_user
      # User.find_by(id: cookies.encrypted[:current_user_id]) || reject_unauthorized_connection
      if (current_user = env["warden"].user)
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end

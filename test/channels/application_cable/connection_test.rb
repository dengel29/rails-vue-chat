require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  def test_connection_success_when_cookie_is_set_correctly
    user = users(:dan)
    cookies.signed["current_user_id"] = user.id 
    
    # Simulate the connection
    connect

    # Assert if the correct user is set
    assert_equal user.id, connection.current_user.id
  end

  def test_connection_rejected_without_cookie_set
    assert_reject_connection { connect }
  end
end

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "that new page loads" do
    get login_path
    assert_response :success
  end

end

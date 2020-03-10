require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user)
    @user2 = users(:example_user_2)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'that user is redirected when editing incorrect profile' do
    log_in_as(@user2)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'that user is redirected when updating incorrect profile' do
    log_in_as(@user2)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'that index should redirect when user is not logged in' do
    get users_path
    assert_redirected_to login_url
  end
end

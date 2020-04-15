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
  
  test 'that admin attribute is not editable via the web' do
    log_in_as @user2
    assert_not @user2.admin?
    patch user_path(@user2), params: { user: { password: 'password',
                                               password_confirmation: 'password',
                                               admin: true}}
    assert_not @user2.reload.admin?
  end

  test 'that users are redirected if not logged in'do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end  
    assert_redirected_to login_url
  end

  test 'that only admins can delete a user' do
    log_in_as @user2
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "that an admin can delete a user" do
    log_in_as @user
    assert_difference "User.count", -1 do
      delete user_path(@user2)
    end
  end

  test "that user is redirected from the following page when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test "that user is redirected from the followers page when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example_user)
  end
  
  test 'that login with valid email/ invalid password results in error messages that do not persist' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'valid@email.com', password: 'invalid' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'that login with valid info changes the available links' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path , count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end

  test 'that valid login followed by logout' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                               password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a[href=?]', login_path , count: 0
    # logout user
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # simulate a user clicking 'logout' in a second window
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')
    # assigns: gives us access to the instance variable(@user) passed in the create action of the controller
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test 'login without remembering' do
    # log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # log in again and verify cookie was deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end

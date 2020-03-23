require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user)
  end

  test 'that invalid update info does not update the current_user' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', 
                                              email: 'invalid@email',
                                              password: 'bad',
                                              password_confirmation: 'password'}}
    assert_not flash.empty?
    assert_template 'users/edit'
    # test error messages
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'div.alert', 'The form contains 4 errors.'
    # test flash message
    assert_select 'div.alert-warning'
  end

  test 'that valid update info does update the current_user' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    user_name = 'updated name'
    user_email = 'updated@example.com'
    patch user_path(@user), params: { user: { name: user_name,
                                              email: user_email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    # check user details 
    @user.reload
    assert_equal user_name, @user.name
    assert_equal user_email, @user.email
  end

  test 'that user is redirected from edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'that user is redirected from update when not loged in' do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "that user is redirected to edit page if they weren't logged in and log in successfully (Friendly forwarding)" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    user_name = "Updated name"
    user_email = "updated@email.com"
    patch user_path(@user), params: { user: { name: user_name, email: user_email } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal user_name, @user.name
    assert_equal user_email, @user.email
  end
end

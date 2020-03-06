require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user)
  end

  test 'that invalid update info does not update the current_user' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', 
                                              email: 'invalid@email',
                                              password: 'bad',
                                              password_confirmation: 'password'}}
    assert_not flash.empty?
    assert_template 'users/edit'
    # test error messages
    assert_select 'div#error-explanation'
    assert_select 'div.field_with_errors'
    assert_select 'div.alert', 'The form contains 4 errors.'
    # test flash message
    assert_select 'div.alert-warning'
  end

  test 'that valid update info does update the current_user' do
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
end

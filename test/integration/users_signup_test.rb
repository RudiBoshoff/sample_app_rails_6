require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'that invalid signup info does not create a new user' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                        email: "invalid@email",
                                        password: '0000',
                                        password_confirmation: '1234'}}
    end
    assert_template 'users/new'
    # test error messages
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'that valid signup info with account activation creates a new user' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Test User",
                                         email: "valid@email.com",
                                         password: "password",
                                         password_confirmation: "password"}}
    end
    # check that email containing activation token was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # try to log in before user is activated
    assert_not user.activated?
    log_in_as user
    assert_not is_logged_in?
    # try to activate with invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not user.activated?
    assert_not is_logged_in?
    # try to activate with invalid email
    get edit_account_activation_path(user.activation_token, email: "wrong@email.com")
    assert_not user.activated?
    assert_not is_logged_in?
    # try activate with valid email and token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end

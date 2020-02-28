require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
    assert_select 'div#error-explanation'
    assert_select 'div.field_with_errors'
    # test flash message
    assert_select 'div.alert-warning'
  end

  test 'that valid signup info creates a new user' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Test User",
                                         email: "Test@email.com",
                                         password: "password",
                                         password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template 'users/show'
    # test flash message
    assert_select "div.alert-success", count: 1
  end
end

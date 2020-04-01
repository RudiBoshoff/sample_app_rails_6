require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:example_user)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # Try reset the password with an invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"
    # Try reset the password with a valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # Check that the reset email was sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # password reset form
    user = assigns(:user)
    # Try reset the password with a wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Try reset the password with a user that has not been activated
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Try reset the password with the correct email but wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    # Try reset the password with the correct email and correct token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Try update the password with invalid password and confirmation
    patch password_reset_path(user.reset_token), 
                                    params: { email: user.email, 
                                              user: { password:              "mismatch",
                                                      password_confirmation: "matchmis" } }
    assert_select 'div#error_explanation'
    # Try update the password with empty password and confirmation
    patch password_reset_path(user.reset_token), 
                                    params: { email: user.email, 
                                              user: { password:              "",
                                                      password_confirmation: "" } }
    assert_select 'div#error_explanation'                                                 
    # Try update the password with valid password and confirmation
    patch password_reset_path(user.reset_token), 
                                    params: { email: user.email, 
                                              user: { password: "password",
                                                      password_confirmation: "password" } }
    assert is_logged_in?
    # Check that the reset digest has been cleared after a successful password change
    assert_nil user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to user
  end

  test 'expired reset token' do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    # Try update the password with valid password and confirmation but reset token has expired.
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
                               params: { email: @user.email,
                                         user: { password:      "foobar",
                                         password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match (/expired/i), response.body                                              
  end
end

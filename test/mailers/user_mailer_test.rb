require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'that activation email renders correctly and contains the activation_token in the link' do
    user = users(:example_user)
    user.activation_token = User.new_token
    # render the email
    mail = UserMailer.account_activation(user)
    # check the conponents of the rendered email
    assert_equal "Account activation",    mail.subject
    assert_equal [user.email],              mail.to
    assert_equal ["noreply@example.com"],   mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "User", email: "valid@example.com",
                     password: '123456', password_confirmation: '123456')
  end
  
  test "that user is valid" do
    assert @user.valid?
  end

  test "that user name is present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test 'that user email is present' do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test 'that user name is not too long' do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test 'that user email is not too long' do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  test 'that user email has the correct format' do
    valid_addresses = %w[email@example.com
                      USER@foo.COM
                      a_US-er@foo.bar.org 
                      first.last@foo.net
                      foo+bar@net.cn]

    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'that an invalid user email is rejected' do
    invalid_addresses = %w[user@example,com
                        user_at_foo.org
                        user.name@example.
                        foo@bar_baz.com
                        foo@bar_baz..com
                        foo@bar+baz.com]

    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test 'that user email is unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'that email is downcased' do
    @user.email.upcase!
    @user.save 
    assert_equal @user.email, @user.email.downcase
  end

  test 'that password has a minimum length' do
    @user.password = @user.password_confirmation = "123"
    assert_not @user.valid?
  end

  test 'that password is not blank' do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test 'that authenticated? returns false for a user with a remember_token of nil' do
    assert_not @user.authenticated?(:remember, '')
  end
end

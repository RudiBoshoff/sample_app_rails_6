require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example_user)
  end
  
  test '' do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    assert_select 'a[href=?]', user_path(@user), count: 1
  end
end

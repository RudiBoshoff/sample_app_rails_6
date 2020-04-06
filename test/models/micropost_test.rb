require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:example_user)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "that micropost is valid" do
    assert @micropost.valid?
  end

  test "that the user id is present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "that content is present" do
    @micropost.content = "    "
    assert_not @micropost.valid?
  end

  test "that content is smaller than 140 characters" do
    @micropost.content = "x" * 141
    assert_not @micropost.valid?
  end

  test "that order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end

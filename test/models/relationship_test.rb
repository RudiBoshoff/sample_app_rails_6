require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    @relationship = Relationship.new(follower_id: users(:example_user).id,
                                     followed_id: users(:example_user_2).id)
  end

  test "that @relationship is valid" do
    assert @relationship.valid?
  end

  test "that @relationship contains a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "that @relationship contains a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end

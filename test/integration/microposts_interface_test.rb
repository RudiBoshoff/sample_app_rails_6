require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:example_user)
  end
  
  test "that the micropost interface displays correctly" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # Attempt to create a new micropost with invalid info
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # check pagination link is correct
    assert_select 'a[href=?]', '/?page=2'

    # Attempt to create a new micropost with valid info
    content = "This micropost really ties the room together"
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert assigns(:micropost).image.attached?
    follow_redirect!
    assert_match content, response.body

    # Attempt to delete a micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit a different user's page and attempt to delete a micropost (no links)
    get user_path(users(:example_user_2))
    assert_select 'a', { text: 'delete', count: 0 }
  end

  test 'that the micropost sidebar count is correct' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:example_user_5)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    # create a micropost for that user
    other_user.microposts.create!(content: "A micropost")
    get root_path
    # check that the micropost was created
    assert_match "1 micropost", response.body
  end 
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # returns true if a test user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end


  # Why a different class?
  # Inside controller tests, we can manipulate the session method directly,
  # assigning user.id to the :user_id key
  
  # Log in as a particular user
  def log_in_as(user)
    session[:user_id] = user.id
  end
  
end

class ActionDispatch::IntegrationTest
  # Why a different class?
  # Inside integration tests, we can’t manipulate session directly, 
  # but we can post to the sessions path

  # Log in as a particular user.
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

end
class ApplicationController < ActionController::Base

    # allows the helper to be used in controllers
    include SessionsHelper

    private

    # moved here from the users controller as the micropost controller requires teh user to be logged in as well
        # confirms a user is logged in
        def logged_in_user
            unless logged_in?
              store_location
              flash[:danger] = "Please log in."
              redirect_to login_url
            end
        end
end

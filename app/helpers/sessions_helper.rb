module SessionsHelper

    # Logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end

    # returns the current logged-in user (if any)
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    # returns true if the user is logged in, flase otherwise
    def logged_in?
        !current_user.nil?
    end

    # logs out current user by removing the user id from sessions hash
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
    
end

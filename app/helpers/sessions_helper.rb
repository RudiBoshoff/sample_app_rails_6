module SessionsHelper

    # Logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end

    # Remembers a user in a cookie
    def remember(user)
        # 1. assigns a new token
        # 2. digests the token
        # 3. update the remember_digest in the DB
        user.remember

        # 4. add the encrypted user_id to the cookie hash
        cookies.permanent.encrypted[:user_id] = user.id

        # 5. add the remember_token to the cookie hash
        cookies.permanent[:remember_token] = user.remember_token
    end

    # returns the current logged-in user (if any)
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user&.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # returns true if the user is logged in, flase otherwise
    def logged_in?
        !current_user.nil?
    end

    # forgets a persistent session
    def forget(user)
        # 1. set the remember_digest in DB to nil
        user.forget
        # 2. delete cookies
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # logs out current user by removing the user id from sessions hash
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
    
end

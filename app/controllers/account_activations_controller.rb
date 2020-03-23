class AccountActivationsController < ApplicationController
    # params gets email = user.email and id = activation_token when the user clicks the activation link
    def edit
        user = User.find_by(email: params[:email])

        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:success] = "Account activated!"
            redirect_to user
        else
            flash[:danger] = "Invalid activation link"
            redirect_to root_url
        end
    end
    
end

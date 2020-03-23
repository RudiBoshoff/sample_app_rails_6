class AccountActivationsController < ApplicationController
    # params gets email = user.email and id = activation_token when the user clicks the activation link
    def edit
        user = User.find_by(email: params[:email])

        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.update_attribute(:activated, true)
            user.update_attribute(:activated_at, Time.zone.now)
            log_in user
            flash[:success] = "activation activated!"
            redirect_to user
        else
            flash[:danger] = "Invalid activation link"
            redirect_to root_url
        end
    end
    
end

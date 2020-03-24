class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    # cases: 
    # 1. An expired password_reset
    # 2. a failed update due to invalid password
    # 3. a failed update (which looks successful) but password is empty
    # 4. a successful update

    if params[:user][:password].empty?
      # case 3
      @user.errors.add(:password, "can't be empty!")
      render 'edit'
    elsif @user.update(user_params)
      # case 4
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      # case 2
      render 'edit'
    end

  end
  

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # BEFORE FILTERS

    # Find the user in the database using the email passed through params
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms that the user is valid
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    # checks if the reset_token has expired
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
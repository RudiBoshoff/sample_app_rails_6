class UsersController < ApplicationController
  # User must be logged in in order to update a profile
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
   
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."   
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "Profile successfully updated"
      redirect_to @user
    else
      flash.now[:warning] = "User update failed!"
      render 'edit'
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'User was successfully deleted.'
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    ############################################################################################
    #  BEFORE ACTIONS
    ############################################################################################

    # confirms a user is logged in
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    # returns true if the given user is the correct user
    def current_user?(user)
      user &. == current_user
    end

    # Confirms that the user is an admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

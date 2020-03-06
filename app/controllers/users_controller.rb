class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
   
  def create
    @user = User.new(user_params)
    if @user.save
      # sets the session[:user_id] to the user.id
      log_in @user
      flash[:success] = "User successfully created"
      redirect_to @user
    else
      flash.now[:warning] = "User sign up failed!"
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end

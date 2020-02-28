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
      flash[:success] = "User successfully created"
      redirect_to @user
    else
      flash[:warning] = "User sign up failed!"
      render 'new'
    end
  end
  


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
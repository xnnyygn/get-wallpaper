class UsersController < ApplicationController

  skip_before_action :authorize, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :password, :password_confirmation))
    if @user.save
      redirect_to login_url
    else
      render :new
    end
  end
  
end

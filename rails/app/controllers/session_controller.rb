class SessionController < ApplicationController

  skip_before_action :authorize, only: [:new, :create]
  
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash.now[:alert] = 'Incorrect name and password binding'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

end

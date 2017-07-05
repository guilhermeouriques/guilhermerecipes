class SessionsController < ApplicationController
  
# will simply render the form
  def new
  
  end

# will create the session and move the user to logged in state
  def create
  	chef = Chef.find_by(email: params[:session][:email].downcase)
    if chef && chef.authenticate(params[:session][:password])
      session[:chef_id] = chef.id
      flash[:success] = "You have successfully logged in"
      redirect_to chef
    else
    flash.now[:danger] = "There was something wrong with your login information"
      render 'new'
    end
  end

# will end the session or simulate logged out state
  def destroy
    session[:chef_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end

end 
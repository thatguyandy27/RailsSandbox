class SessionsController < ApplicationController

  def new 
    render 'new'
  end

  def create
    session_param = params[:session]
    user = User.find_by(email: session_param[:email].downcase)

    if user && user.authenticate(session_param[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end

  end

  def destroy
    sign_out()
    redirect_to root_url
  end

end

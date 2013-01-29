class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, except: [:destroy]

  def create
    user = User.find_or_create_with_omniauth(request.env['omniauth.auth'])

    if user.persisted?
      session[:user_id] = user.id
    else
      flash[:error] = "No."
    end

    redirect_to root_url
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Bye!"
  end
end

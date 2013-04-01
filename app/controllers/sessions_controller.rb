# -*- encoding : utf-8 -*-

class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, except: [:destroy]

  def new

  end

  def create
    user = User.find_or_create_with_omniauth(request.env['omniauth.auth'])

    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash[:error] = user.errors[:base].first
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to signin_url, notice: "Bye!"
  end
end

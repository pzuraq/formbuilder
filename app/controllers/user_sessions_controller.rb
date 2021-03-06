class UserSessionsController < ApplicationController
  before_filter :require_login, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:username], params[:password])
      @user_group = Group.where(:owner => @user, :parent_id => [false, nil]).first!
      redirect_to(@user_group, notice: 'Login Successful')
    else
      flash.now[:alert] = 'Login Failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:login, notice: 'Logged Out!')
  end
end

class UsersController < ApplicationController
  before_action :find_user, only: [:show, :create]

  def new
    @user = User.new
  end

  def create
    if @user.save
      log_in @user
      flash[:success] = t "static_pages.home.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    id = params[:id]
    @user =
      if id
        User.find_by id: id
      else
        User.new user_params
      end
    unless @user
      flash[:danger] = t "static_pages.home.invalid_login"
      redirect_to root_url
    end
  end
end

class UsersController < ApplicationController
  before_action :find_user, except: [:index, :new]
  before_action :logged_in_user, only: [:index, :edit, :update]

  def index
    @users = User.all
  end

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

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "static_pages.home.profile_updated"
      redirect_to @user
    else
      render :edit
    end
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

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "static_pages.home.please_login"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end
end

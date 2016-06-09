class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  def index
  	per_page = params[:per_page] || 10
  	@users = User.paginate(:page => params[:page], :per_page => per_page)
  	if params
  		@users = User.filter(params).paginate(:page => params[:page], :per_page => per_page)
  	end

  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
	  if @user.save
	  	log_in @user
        redirect_to @user
	  else
	    render 'new'
	  end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_path
  end


	private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :age, :city, :avatar)
  end

      # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end

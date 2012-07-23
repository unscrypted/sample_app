class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    if signed_in?
      flash[:error] = "You are already signed in."
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      flash[:error] = "You are already signed in."
      redirect_to root_path
    else
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Congratulations, your profile has been created!  Welcome to the Sample App!!"
        redirect_to @user
      else
        render 'new'
      end
    end 
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Your profile has successfully been updated."
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User successfully deleted."
    redirect_to users_path
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in to access this page."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

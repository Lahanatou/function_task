class UsersController < ApplicationController
  before_action :correct_user, only: [:show]
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to user_path(@user.id), notice: 'Non spécifié Compte enregistré.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    #devise_mailer.send("sample@gmail.com").deliver_later
    ContactMailer.contact("sample@gmail.com").deliver_later

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end
end

class PasswordResetController < ApplicationController

  def new
  end

  def create
    puts "RESET #{password_reset_params[:email]}"
    @user = User.find_by_email(password_reset_params[:email])

    if @user
      @user.set_reset_token
      UserMailer.password_reset(@user).deliver
      flash.now[:success] = 'Please check you mail box'
      redirect_to login_path
    else
      flash.now[:danger] = 'Please enter a valid email'
      redirect_to login_path
    end
  end

  def show
    @user = User.find_by_reset_token(params[:id])

    if !@user
      flash.now[:danger] = 'Ooooppss. Something went wrong.'
      redirect_to login_path
    end
  end

  def update
    @user = User.find_by_reset_token!(params[:id])

    @user.password = user_params[:password]
    if @user.save
      @user.confirm_password_reset
      flash.now[:success] = 'Password reseted'
      redirect_to login_path
    else
      flash.now[:danger] = 'Error'
      redirect_to login_path
    end
  end

  private

  def password_reset_params
    params.require(:password_reset).permit(:email)
  end

  def user_params
    params.require(:user).permit(:password)
  end

end

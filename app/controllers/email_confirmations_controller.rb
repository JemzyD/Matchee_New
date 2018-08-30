class EmailConfirmationsController < ApplicationController
  def show
    @user = User.find_by_confirm_token(params[:id])

    if @user
      @user.email_activate
      flash[:success] = "Welcome to the Matchee. Your email has been confirmed. \n Please sign in to continue."
      redirect_to login_url
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end
end

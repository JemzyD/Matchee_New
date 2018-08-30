class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def is_authenticated
    unless current_user
      flash[:danger] = "Credentials Invalid!!"
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_freelancer
    @current_freelancer ||= Freelancer.find_by(user_id: current_user[:id])
  end
  
helper_method :current_user
helper_method :current_freelancer
end

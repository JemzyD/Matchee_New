class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash.now[:success] = 'Please check you mail box and confirm email'
      redirect_to email_confirmations_path
    else
      flash.now[:error] = "Ooooppss, something went wrong!"
      redirect_to login_path
    end
  end

  def update
    upload_picture
    @user.update(user_params)

    if @user
      flash.now[:success] = 'You have successfully updated your profile'
      redirect_to user_path(@user)
    else
      flash.now[:error] = "Ooooppss, something went wrong!"
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :address, :profile_picture)
  end

  def upload_picture
   if params[:user][:profile_picture] != nil
     if @user.valid?
       uploaded_file = params[:user][:profile_picture].path
       cloudnary_file = Cloudinary::Uploader.upload(uploaded_file)
       @user.profile_picture = cloudnary_file['public_id']
     else
       cloudnary_file = Cloudinary::Uploader.upload("../assets/images/default.png")
       @freelancer.picture = cloudnary_file['public_id']
     end
     params[:user].delete :profile_picture
   end
end

end

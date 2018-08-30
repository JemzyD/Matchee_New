class RatingsController < ApplicationController
  before_action :is_authenticated
  
  def create
    @rating = Rating.new(rating_params)
    @rating.user_id = current_user.id
    if @rating.save
      redirect_to profile_path(@rating.freelancer_id)
    end
  end

  def show
    @rating = Rating.new
    @freelancer = Freelancer.find_by(id: params[:id])
  end

  private
  def rating_params
    params.require(:rating).permit(
      :professionalism,
      :value,
      :cleanliness,
      :description_of_job,
      :freelancer_id
    )
  end
end

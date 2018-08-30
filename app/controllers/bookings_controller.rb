class BookingsController < ApplicationController
  before_action :check_user
  before_action :is_freelancer?
  before_action :enquiry_status_accept, only: [:create]

  def create
    # ENQUIRY SEARCH
    @enquiry = Enquiry.find(params[:enquiry][:id])
    # FREELANCER SEARCH BY ENQUIRY freelancer_id
    @freelancer = Freelancer.find(@enquiry.freelancer_id)
    # SCRUB PARAMS STRING TO TIME
    start_date = params[:enquiry][:start_date].to_time
    end_date = params[:enquiry][:end_date].to_time
    # BOOK FREELANCER
    if @enquiry.book! @freelancer, time_start: start_date, time_end: end_date
      flash[:success] = 'User booked!'
      redirect_to edit_enquiry_path(@enquiry)
    else
      flash[:danger] = 'Error in booking..'
      redirect_to edit_enquiry_path(@enquiry)
    end
  end

  def index
    @bookings_fl = current_freelancer.bookings
  end

  def update
    @enquiry = Enquiry.find_by(user_id: current_freelancer.id)

    if (enquiry.bookings.length > 0)
      @enquiry.status = 'done'
        if @enquiry.save!
         flash[:success] = 'Booking completed!'
         redirect_to edit_enquiry_path(@enquiry)
        else
         flash[:danger] = 'Error in booking..'
         redirect_to edit_enquiry_path(@enquiry)
        end
    end
  end

  private

  def booking_params
    params.require(@enquiry).permit(
      :description,
      :start_date,
      :end_date,
      :price,
      :id)
  end

  def is_freelancer?
    if !current_freelancer
      flash[:danger] = 'Unauthorized user!!'
      redirect_to profile_index_path
    end
  end

  def check_user
    if !current_user
      flash[:danger] = 'Please login in to use the service!'
      redirect_to login_path
    end
  end

  def enquiry_status_accept
    enquiry = Enquiry.find_by(id: params[:enquiry][:id])
    # debugger
    enquiry.status = 'accepted'
    enquiry.save!
  end
end

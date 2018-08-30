class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy]
  before_action :is_authenticated, only: [:index, :edit, :update, :destroy]


  def index
    # @enquiries = Enquiry.where("user_id=?", @current_user.id)
    @enquiries = Enquiry.where("user_id =?", current_user.id)
    @freelancers = Freelancer.all
  end

  def show
    redirect_to signup_path  if @enquiry.user_id != current_user.id && @enquiry.freelancer.user_id != current_user.id
    @occurrences = {
       dates: @enquiry.freelancer.schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year),
       start_time: @enquiry.freelancer.schedule.start_time.strftime("%I:%M%p"),
       end_time: @enquiry.freelancer.schedule.end_time.strftime("%I:%M%p"),
       start_date: @enquiry.start_date
     }
  end

  def edit
    if @enquiry.user_id != current_user.id && @enquiry.freelancer.user.id != current_user.id
      flash[:danger] = 'No access rights'
      redirect_to root_path
    end

    @occurrences = {
       dates: @enquiry.freelancer.schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year),
       start_time: @enquiry.freelancer.schedule.start_time.strftime("%I:%M%p"),
       end_time: @enquiry.freelancer.schedule.end_time.strftime("%I:%M%p"),
       start_date: @enquiry.start_date
     }
    Message.clear_unread(@enquiry.messages, current_user)

  end

  def new
    @enquiry = Enquiry.new
    @freelancer = Freelancer.find(params[:profile_id])
    @occurrences = {
      dates: @freelancer.schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year),
      start_time: @freelancer.schedule.start_time.strftime("%I:%M%p"),
      end_time: @freelancer.schedule.end_time.strftime("%I:%M%p")
    }
    puts "freelancer id is #{@freelancer.id}"
  end

  def create
    enquiry = Enquiry.where('freelancer_id =? AND status = ? AND user_id =? ', enquiry_params[:freelancer_id], 'open', current_user.id)

    if enquiry.size > 0
      flash[:danger] = "Can't create"
      redirect_to root_path
    else



    @enquiry = Enquiry.new(enquiry_params)
    @enquiry.user_id = current_user.id
    # @freelancer = Freelancer.find(params[:profile_id])
    # @enquiry.freelancer_id = @freelancer.id

    @enquiry.save!
      redirect_to enquiry_path(@enquiry), notice: 'Enquiry was successfully created.'
    end
  end

  def update
    respond_to do |format|
      changes = @enquiry.check_update(enquiry_params)
      if @enquiry.update(enquiry_params)
        @enquiry.send_auto_message(changes, current_user.id) if changes.size > 0
        format.html { redirect_to edit_enquiry_path(@enquiry), notice: 'Enquiry was successfully updated.' }
        format.json { render :show, status: :ok, location: @enquiry }
      else
        format.html { render :edit }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @enquiry.destroy
    respond_to do |format|
      format.html { redirect_to enquiries_url, notice: 'Enquiry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_enquiry
    @enquiry = Enquiry.find(params[:id])
  end

  def enquiry_params
    params.require(:enquiry).permit(:name, :description, :start_date, :end_date, :user_id, :freelancer_id, :price, :status, :id)
  end

end

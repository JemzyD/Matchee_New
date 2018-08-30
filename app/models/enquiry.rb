class Enquiry < ApplicationRecord
  belongs_to :user
  belongs_to :freelancer
  has_many :messages

  before_save :default_enquiry_time_range, :if => :check_time_range
  before_update :default_enquiry_time_range, :if => :check_time_range

  # BOOKABLE GEM (ANDREW)
  acts_as_booker

  def check_time_range

    if self.start_date == nil && self.start_date == nil
      return true
    else
      return false
    end
  end

  def default_enquiry_time_range

    self.start_date = self.created_at.to_time.utc
    self.end_date = self.created_at.to_time.utc
  end

#   after_create :deliver
#
# @@REMINDER_TIME = 30.minutes # minutes before appointment
#
# # Notify our appointment attendee X minutes before the appointment time
# def deliver
#   @client = Twilio::REST::Client.new TWILIO_CONFIG['sid'], TWILIO_CONFIG['token']
#   message = @client.account.messages.create(:body => "Appointment msg",
#       :to => current_user.phone,    # Replace with your phone number
#       :from => TWILIO_CONFIG['from'])  # Replace with your Twilio number
#
#   puts "message entered"
# end
# #
# # def when_to_run
# #   time - @@REMINDER_TIME
# # end
#
# handle_asynchronously :deliver, :run_at => Proc.new { 30.minutes.from_now }

  def opposed_user(current)
    if current == freelancer.user
          user
    else
         freelancer.user
    end
  end

  def check_update(params)
    changes = {}
    params.each_pair do |key, value|
      if key == 'start_date' || key == 'end_date'
        changes[key] = value if self[key].to_time != value.to_time
      elsif key == 'price'

        changes[key] = value if self[key].to_s != value.to_s
      else
        changes[key] = value if self[key] != value
      end
    end
    changes
  end

  def send_auto_message(changes, user)
    content  = ' '
    changes.each_pair do |key, value|
      if key == 'start_date'
          name = "Start Date"
          render_value = value.to_date.to_s + ' ' + value.to_datetime.hour.to_s + ':' + value.to_datetime.minute.to_s
      elsif key == 'end_date'
        name = "End Date"
        render_value = value.to_date.to_s + ' ' + value.to_datetime.hour.to_s + ':' + value.to_datetime.minute.to_s
      else
         name = key
         render_value = value
      end


      content = content + '<br>' + name.capitalize + ':<strong> '+ render_value + '</strong>'
    end
    self.messages.create!(content: "#{content} <br> Changed ", sender_id: user)

    ActionCable.server.broadcast(
      "enquiry_channel_#{self.freelancer.user.id}",
      changes: changes,
      enquiry_id: self.id,
    )
  end

end

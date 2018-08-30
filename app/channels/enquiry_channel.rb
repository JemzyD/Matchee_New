class EnquiryChannel < ApplicationCable::Channel
  def subscribed

     stream_from "enquiry_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
     hash[el.values.first] = el.values.last
   end

    Message.create!(message_params)
  end

end

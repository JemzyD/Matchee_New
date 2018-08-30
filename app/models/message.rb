class Message < ApplicationRecord
  belongs_to :enquiry
  belongs_to :sender, class_name: User


  after_create_commit { MessageBroadcastJob.perform_now(self) }

  def self.clear_unread(messages, user)
    messages.where.not(sender_id: user.id).each do |message|
      message.update(read: true)
    end
  end

end

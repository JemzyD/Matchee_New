class User < ApplicationRecord
  before_create :set_confirmation_token
  has_many :messages
  has_one :freelancer
  has_many :enquiries

  validates :name,
  presence: true,
    length: { in: 3..72}

  validates :email,
  presence: true,
  uniqueness: {case_sensitive: false}

  validates :password,
  length: { in: 8..72},
  on: :create

  has_secure_password

  def self.authenticate(params)
    User.find_by_email(params[:email]).try(:authenticate, params[:password])
  end

  def email_activate
    self.update_columns(email_confirmed: 1, confirm_token: nil)
  end

  def confirm_password_reset
    self.update_columns(reset_confirmed: 1, reset_token: nil)
  end

  def set_reset_token
      self.update_columns(reset_confirmed: 0, reset_token: SecureRandom.urlsafe_base64.to_s, email_confirmed: 1)
  end

  private

  def set_confirmation_token
    if self.confirm_token.blank?
      self.email_confirmed = 1
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end


end

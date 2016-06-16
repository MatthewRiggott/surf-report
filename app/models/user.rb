class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  after_create :send_welcome_mail

  belongs_to :alert

  private

  def send_welcome_mail
    UserMailer.welcome_email(self).deliver_now
  end

end

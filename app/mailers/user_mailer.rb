class UserMailer < ApplicationMailer
  default from: "SurfReport.notifier@gmail.com"
  def welcome_email(user)
    @user = user
    @url = 'https://surf-report.herokuapp.com'

  end
end

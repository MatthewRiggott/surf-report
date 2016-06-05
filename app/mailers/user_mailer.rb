class UserMailer < ApplicationMailer
  default from: "surfreport.notifier@gmail.com"
  def welcome_email(user)
    @user = user
    @url = 'https://surf-report.herokuapp.com'
    mail(to: @user.email, subject: "Welcome")
  end
end

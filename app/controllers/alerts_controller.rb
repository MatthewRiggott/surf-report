class AlertsController < ApplicationController

  def new
    #if current_user
      @alert = Alert.new
    #else
    #  redirect_to new_user_registration_path
    #end
  end

  def create
    @alert = current_user.alert
    @alert(monday)
    binding.pry
  end

end

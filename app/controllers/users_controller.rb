class UsersController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.new(user_params)
    if !@user.save
      # ERROR
      redirect_to root_url
    else
      StageMailer.confirm.deliver_now
      redirect_to root_url
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:email)
    end
end

class AlertsController < ApplicationController
  def create
    # 未ログインの場合
    @stage = Stage.find(alert_params[:stage_id])
    if !@stage
      redirect_to root_url
    end
#    @user = User.find_by(email: user_params[:email])
#    if !@user
#      redirect_to root_url
#    end
    
    #@stage_id = alert_params[:stage_id]
    #@user = User.find_by(:email, param[:email])
  end
  
  private
  
    def alert_params
      params.require(:alert).permit(:stage_id)
    end
    
    def user_params
      params.require(:user).permit(:email)
    end
end

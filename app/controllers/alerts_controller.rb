class AlertsController < ApplicationController
  def create
    # 未ログインの場合
    @stage = Stage.find(alert_params[:stage_id])
    if !@stage
      redirect_to root_url
    end
    
    @user = User.find_by(email: alert_params[:email])
    if !@user
      @user = User.new(email:alert_params[:email])
      if !@user.save
        redirect_to @stage, flash: { error: @user.errors.full_messages }
      end
    end
    
    #@stage_id = alert_params[:stage_id]
    #@user = User.find_by(:email, param[:email])
  end
  
  private
  
    def alert_params
      params.require(:alert).permit(:stage_id, :email)
    end

end

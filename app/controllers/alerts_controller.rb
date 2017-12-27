class AlertsController < ApplicationController
  def create
    # 未ログインの場合
    if !logged_in?
      redirect_to root_url
    end
      
    @stage = Stage.find(alert_params[:stage_id])
    if !@stage
      redirect_to root_url
    end

    @user = current_user
    
    @alert = Alert.new(
      stage_id: @stage.id,
      user_id: @user.id,
      seven_days: alert_params[:seven_days],
      three_days: alert_params[:three_days],
      one_day: alert_params[:one_day],
      )
    if !@alert.save
      #flash[:danger] = @alert.errors.full_messages
      return redirect_to @stage, flash: { error: @alert.errors.full_messages }
    end
    StageMailer.confirm(@user.email, @alert).deliver_now
    flash[:success] = "メール通知を登録しました。通知確認用のメールをご確認ください。"
    
    redirect_to root_url
  end
  
  private
  
    def alert_params
      params.require(:alert).permit(:stage_id, :seven_days, :three_days, :one_day)
    end

end

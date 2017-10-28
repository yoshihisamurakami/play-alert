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
        return redirect_to @stage, flash: { error: @user.errors.full_messages }
      end
    end

    @alert = Alert.new(
      stage_id: @stage.id,
      user_id: @user.id,
      seven_days: alert_params[:seven_days],
      three_days: alert_params[:three_days],
      one_day: alert_params[:one_day],
      )
    if !@alert.save
      return redirect_to @stage, flash: { error: @alert.errors.full_messages }
    end
    StageMailer.confirm(alert_params[:email]).deliver_now
    flash[:success] = "通知登録しました。通知確認用のメールをご確認ください。"
    
    redirect_to root_url
  end
  
  private
  
    def alert_params
      params.require(:alert).permit(:stage_id, :email, :seven_days, :three_days, :one_day)
    end

end

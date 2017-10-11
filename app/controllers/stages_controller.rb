class StagesController < ApplicationController
  def index
    @stages = Stage.page(params[:page])
  end
  
  def show
    @stage = Stage.find(params[:id])
    @user  = User.new
    @alert = Alert.new
    #@user.stage = @stage 
    #StageMailer.confirm.deliver_now # メール送信
  end
end

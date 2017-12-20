class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # OK
      log_in user
      redirect_to root_path
    else
      # ERROR
      flash.now[:danger] = "ユーザーが存在しないか、ユーザー名とパスワードの組み合わせが正しくありません。"
      render 'new'
    end
  end
  
  def destroy
  end
end

class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "指定したメールアドレス宛てにパスワード再設定用のURLを送りました。"
      redirect_to root_url
    else
      flash.now[:danger] = "指定したメールアドレスのユーザーが見つかりませんでした。"
      render 'new'
    end
  end

  def edit
  end
end

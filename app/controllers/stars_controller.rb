class StarsController < ApplicationController
  
  def set
    if logged_in?
      set_on_login
    else
      set_on_notlogin
    end
    
    result = {result: 'OK'}
    render :json => result
  end
  
  def unset
    if logged_in?
      unset_on_login
    else
      unset_on_notlogin
    end
    render :json => {result: 'OK'}
  end

  private
  
  def set_on_login
    user_star = UserStar.new(user: current_user, stage_id: params[:id])
    user_star.save
  end
  
  def set_on_notlogin
    stars = []
    star = cookies.signed[:stars]
    if star.nil?
      star = params[:id]
      stars = [star]
    else
      stars = star.split(',')
      unless stars.include?(params[:id])
      stars << params[:id]
      end
    end
    cookies.signed[:stars] = stars.join(',')
  end
  
  def unset_on_login
    user_star = UserStar.find_by(user: current_user, stage_id: params[:id])
    if !user_star.nil?
      user_star.destroy
    end
  end
  
  def unset_on_notlogin
    stars = []
    star = cookies.signed[:stars]
    unless star.nil?
      stars = star.split(',')
      stars.delete(params[:id])
      cookies.signed[:stars] = stars.join(',')
    end
  end

end
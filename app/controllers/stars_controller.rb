class StarsController < ApplicationController
  
  def set
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

    result = {result: 'OK'}
    render :json => result
  end
  
  def unset
    stars = []
    star = cookies.signed[:stars]
    unless star.nil?
      stars = star.split(',')
      stars.delete(params[:id])
      cookies.signed[:stars] = stars.join(',')
    end
    render :json => {result: 'OK'}
  end

end
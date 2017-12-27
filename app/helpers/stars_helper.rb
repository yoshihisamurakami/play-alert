module StarsHelper
  
  def stars
    @stars ||= logged_in? ? stars_on_login : stars_on_notlogin
  end
  
  def stars_on_login
    stars = UserStar.select(:stage_id).where(user: current_user)
    result = []
    stars.each do |star|
      result.push(star.stage_id.to_s)
    end
    result
  end
  
  def stars_on_notlogin
    star_str = cookies.signed[:stars]
    (star_str) ? star_str.split(',') : []
  end

end
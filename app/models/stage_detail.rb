class StageDetail < ApplicationRecord
  belongs_to :stage
  include StagesHelper
  
  def json
    {
      playwright: is_visible?(playwright) ? playwright : '',
      director: is_visible?(director) ? director : '',
      cast: is_visible?(cast) ? cast : '',
      price: is_visible?(price) ? price : '',
      timetable: is_visible?(timetable) ? timetable : '',
      site: is_visible?(site) ? site : '',
    }
  end
end


class GetStages
  STAGES_URL = 'https://stage.corich.jp/stage/'.freeze
  STAGES_DOMAIN = 'https://stage.corich.jp'.freeze
  TIMEOUT = 10.freeze
  SLEEPTIME = 2.freeze
  STAGES_COUNT_ON_ONE_PAGE = 20.freeze

  AREA_KANTO = '3' # 関東地方
  AREA_KINKI = '8' # 近畿地方

  class << self
    def execute(order = :order_by_startdate, area = AREA_KANTO)
      page = 1
      urls = []
      loop do
        if order == :order_by_startdate
          url = stages_url_orderby_startdate(page, area)
        elsif order == :orderby_new_arrivals
          url = stages_url_orderby_new_arrivals(page, area)
        else
          break
        end
        p url

        stage_list = StageListParser.new url
        stages = stage_list.parse
        stages.each do |stage|
          next if stage[:enddate].to_date < Date.today
          stage[:area] = area
          stage_id = save_or_update stage
          urls.push stage[:url]
        end
        break if stages.count < STAGES_COUNT_ON_ONE_PAGE
        page += 1
        sleep SLEEPTIME
      end
      urls
    end

    #「初日の古い順」該当ページのURLを返す
    def stages_url_orderby_startdate(page, area)
      if page == 1
        STAGES_URL + 'start?sort=start&area=' + area
      else
        STAGES_URL + 'start?page=%d&sort=start&area=' % [ page ] + area
      end
    end

    def stages_url_orderby_new_arrivals(page, area)
      if page == 1
        STAGES_DOMAIN + '/stage?type=new&area=' + area
      else
        STAGES_DOMAIN + '/stage?page=%d'% [ page ] + '&sort=create&type=new&area=' + area
      end
    end

    def save_or_update(stage)
      if Stage.find_by(url: stage[:url]).nil?
        save(stage)
      else
        update(stage)
      end
    end

    def save(stage)
      @stage = Stage.new(stage_db(stage))
      if @stage.save
        p "保存成功 => " + @stage.url + " " + @stage.enddate.to_s
        @stage.id
      else
        p "保存失敗"
        nil
      end
    end

    def update(stage)
      old = Stage.find_by(url: stage[:url])
      db = stage_db stage
      if (old.title != db[:title]) or (old.group != db[:group]) or
         (old.theater != db[:theater]) or 
         (old.startdate.to_s != db[:startdate]) or
         (old.enddate.to_s != db[:enddate])
         
        if old.update_attributes(db)
          p "更新成功 => " + db[:url]
          old.id
        end
      end
      nil
    end

    def stage_db(stage)
      stage[:title] = stage[:stage]
      stage.delete(:stage)
      stage
    end
  end

end
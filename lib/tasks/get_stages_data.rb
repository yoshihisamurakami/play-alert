class Tasks::GetStagesData
  STAGES_URL = 'http://stage.corich.jp/stage/start'.freeze
  STAGES_DOMAIN = 'http://stage.corich.jp'.freeze
  STAGE_TEST_URL = '/home/ubuntu/workspace/play-alert/test/fixtures/files/stage.html'.freeze
  TIMEOUT = 10.freeze
  
  class << self
    def execute
      delete_past_stages

      after_update = []
      before_update = Stage.pluck(:id)

      page = 1
      loop do
        stages = StagesHtmlParser.parse( stages_url(page) )
        stages.each do |stage|
          stage_id = save_or_update_stage(stage)
          after_update << stage_id if stage_id
        end
        break if stages.count < 20
        page += 1
        sleep 2
      end
      
      tocheck = before_update - after_update
      message = ''
      #puts "to_check => "
      tocheck.each do |id|
        stage = Stage.find(id)
        
        status = Timeout.timeout(TIMEOUT) {
          Net::HTTP.get_response(URI.parse(STAGES_DOMAIN + stage.url)).code
        }
        sleep 2
        message += stage.url + " " + status + "\n"
        if status != "200"
          stage.destroy
        end
      end
      StageMailer.getstages_message(message).deliver_now
    end
    
    # 公演最終日が前日より前の舞台情報は削除
    def delete_past_stages
      yesterday = Date.today - 1
      Stage.where("enddate <= ?", yesterday).destroy_all
    end
    
    def exec_on_development
      stages = StagesHtmlParser.parse( LOCAL_STAGES_FILE )
      stages.each do |stage|
        save_or_update_stage(stage)
      end
    end
    
    def save_or_update_stage(stage)
      if Stage.find_by(url: stage[:url]).nil?
        save(stage)
      else
        update(stage)
      end
    end
    
    def save(stage)
      @stage = Stage.new(stage_db(stage))
      if @stage.save
        #puts "保存成功 url => " + stage[:url]
        @stage.id
      else
        #puts "保存失敗 url => " + stage[:url]
      end
    end
    
    def update(stage)
      old = Stage.find_by(url: stage[:url])
      #puts "update id => " + old.id.to_s
      if old.update_attributes( stage_db(stage) )
        #puts "更新成功 url => " + stage[:url]
        old.id
      else
        #puts "更新失敗 url => " + stage[:url]
      end
    end
    
    def stage_db(stage)
      {
        url: stage[:url],
        title: stage[:stage],
        group: stage[:group],
        theater: stage[:theater],
        startdate: stage[:startdate],
        enddate: stage[:enddate]
      }
    end
    
    def stages_url(page)
      STAGES_URL + '?' + stages_url_parameter(page)
    end
    
    def stages_url_parameter(page)
      # sort=start: 初日の古い順, area=3: 関東
      return 'sort=start&area=3' if page == 1
      'page=%d&sort=start&area=3'%[ page ]
    end
  end
end
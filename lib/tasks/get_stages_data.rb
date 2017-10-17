class Tasks::GetStagesData
  STAGES_URL = 'http://stage.corich.jp/stage/start'.freeze
  #LOCAL_STAGES_FILE = '/home/ubuntu/workspace/play-alert/test/fixtures/files/stagelist.html'.freeze
  #STAGES_URL = '/home/ubuntu/workspace/play-alert/test/fixtures/files/test_lastpage.html'.freeze

  STAGE_TEST_URL = '/home/ubuntu/workspace/play-alert/test/fixtures/files/stage.html'.freeze

  class << self
    def execute
      delete_past_stages

      for page in 1..30 do
        puts stages_url(page)
        stages = StagesHtmlParser.parse( stages_url(page) )
        puts "count => " + stages.count.to_s
        stages.each do |stage|
          save_or_update_stage(stage)
        end
        break if stages.count < 20
        sleep 2
      end
      #troup = StageHtmlParser.parse( STAGE_TEST_URL )
      #puts troup
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
      puts "url => " + stage[:url]
      if Stage.find_by(url: stage[:url]).nil?
        save(stage)
      else
        update(stage)
      end
    end
    
    def save(stage)
      @stage = Stage.new(stage_db(stage))
      if @stage.save
        puts "保存成功 url => " + stage[:url]
      else
        puts "保存失敗 url => " + stage[:url]
      end
    end
    
    def update(stage)
      old = Stage.find_by(url: stage[:url])
      puts "update id => " + old.id.to_s
      if old.update_attributes( stage_db(stage) )
        puts "更新成功 url => " + stage[:url]
      else
        puts "更新失敗 url => " + stage[:url]
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
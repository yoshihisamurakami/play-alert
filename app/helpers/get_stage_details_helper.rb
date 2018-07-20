require 'open-uri'

module GetStageDetailsHelper
  DEFAULT_CHARSET = 'utf-8'
  TITLES_HASH = {
      cast: "出演",
      playwright: "脚本",
      director: "演出",
      price: "料金（1枚あたり）",
      site: "サイト",
      timetable: "タイムテーブル",
  }
  CORICH_URL_DOMAIN = "http://stage.corich.jp"
  NOT_FOUND = "404"
  
  def get_stage_details
    puts "get_stage_details helper start!!"
    msg = ''
    @update_count = 0
    @new_rec = 0
    @updated = 0
    stages = Stage.pluck(:id)
    details = StageDetail.pluck(:stage_id)
    
    # stage レコードがあり、stage_detail にレコードがないデータ
    new_stages = stages - details
    new_stages.sort.each do |stage_id|
      stage = Stage.find(stage_id)
      if update_detail stage
        @new_rec += 1
        @update_count += 1
        break if @update_count >= 100
      end
    end

    if @update_count < 100
      stages = Stage.includes(:stage_detail)
        .where("stage_details.updated_at < ?", 3.days.ago)
        .references(:stage_detail)
      stages.each do |stage|
        if update_detail stage
          @updated += 1
          @update_count += 1
          break if @update_count >= 100
        end
      end
    end
    
    puts "更新件数 => " + @update_count.to_s + "\r\n"
    if (@new_rec + @updated > 0) 
      msg = "新規 : #{@new_rec}  更新 : #{@updated}"
      p msg
      #StageMailer.getstages_message(msg).deliver_now
    end
  end

  def update_detail(stage)
    puts stage.id.to_s + " " + stage.title + " " + stage.url
    
    html = get_html(CORICH_URL_DOMAIN + stage.url)
    if html[:status] == NOT_FOUND
      puts "stage-page not found."
      stage.destroy
      return false
    end
    return false if !html[:html]

    detail = get_detailinfo(html[:html], html[:charset])
    save_detail(stage.id, detail)

    sleep 2
    true
  end

  def get_html(url)
    charset = nil
    begin
      html = open( url ) do |f|
        charset = (f.class == 'Tempfile') ? f.charset : DEFAULT_CHARSET
        f.read
      end
    rescue => e
      return {status: NOT_FOUND} if e.to_s.match(/Not Found/)
      
      msg = "エラークラス -> #{e.class}\r\n"
      msg += "エラーメッセージ -> #{e.message}\r\n"
      msg += "バックトレース -> \r\n"
      msg += "#{e.backtrace}"
      StageMailer.getstages_message(msg).deliver_now
      return nil
    end
    {html: html, charset: charset} 
  end
  
  def get_status(url)
    begin
      open(url) do |f|
        f.status[0]
      end
    rescue => e
      puts e
    end
  end
  
  def nokogiri_parse(html, charset)
    Nokogiri::HTML.parse(html, nil, charset)
  end
  
  def get_detailinfo(html, charset=DEFAULT_CHARSET)
    details = {}
    html_all = nokogiri_parse(html, charset)
    detail_html = html_all.xpath("//div[@id='areaBasic']").inner_html
    detail = nokogiri_parse(detail_html, charset)
    detail.xpath("//tr").each do |node|
      tr_detail = nokogiri_parse(node.inner_html, charset)
      th_text = tr_detail.xpath("//th").inner_html
      td_text = tr_detail.xpath("//td").inner_html

      TITLES_HASH.each do |key, value|
        if th_text.match(value)
          details[key] = get_detailvalue(key, td_text, charset)
        end
      end
    end
    details[:crawl_date] = Time.current
    details
  end
  
  def get_detailvalue(key, val, charset)
    if key == :site
      detail = nokogiri_parse(val, charset)
      return detail.xpath("//a").inner_html
    end
    val
  end
  
  def need_update?(stage_id)
    detail = StageDetail.find_by(stage_id: stage_id)
    return true if detail.nil?
    
    # (3日以内にレコードが更新されていたらfalseを返す)
    return false if detail.updated_at > 3.days.ago
    true
  end
  
  def save_detail(stage_id, detail)
    old_detail = StageDetail.find_by(stage_id: stage_id)
    @stage = Stage.find(stage_id)
    if old_detail.nil?
      @detail = @stage.build_stage_detail(detail)
      return @detail.save
    end
    old_detail.update_attributes(detail)
  end
end
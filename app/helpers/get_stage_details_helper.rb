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
  
  def get_stage_details
    puts "get_stage_details helper start!!"
    
    stages = Stage.all
    count=0
    stages.each do |stage| 
      puts stage.title + " " + stage.url
      next unless need_update?(stage.id)
      puts "details update!"
      
      html = get_html(CORICH_URL_DOMAIN + stage.url)
      detail = get_detailinfo(html[:html], html[:charset])
      p detail
      save_detail(stage.id, detail)
      sleep 2
    end
    puts "更新件数 => " + count.to_s
    return
  end

  def get_html(url)
    charset = nil
    html = open( url ) do |f|
      charset = (f.class == 'Tempfile') ? f.charset : DEFAULT_CHARSET
      f.read
    end
    {html: html, charset: charset} 
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
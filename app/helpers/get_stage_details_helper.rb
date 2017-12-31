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
    
  def get_stage_details
    puts "get_stage_details helper start!!"
    
    stages = Stage.all
    #stages.each do |stage| 
    #  puts stage.title + " " + stage.url
    #end

    #url = "http://stage.corich.jp/stage/88329"
    #html = get_html(url)
    #puts html[:html]
    
    tmp_file = File.open("/tmp/t.html", "r")
    tmp_html = tmp_file.read
    tmp_file.close

    details = get_detailinfo(tmp_html, 'utf-8')
    p details
    
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
end
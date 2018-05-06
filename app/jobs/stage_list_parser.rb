
class StageListParser

  DEFAULT_CHARSET = 'utf-8'
  
  def initialize(url)
    @url = url
  end

  def parse
    html   = HtmlParser.html @url
    stages_nodes = _stages(html)
    stages = []
    stages_nodes.each do |node|
      stage = _stage(node, html[:charset])
      stages.push(stage)
    end
    stages
  end
    
  private

  
  def _stages(html)
    doc = HtmlParser.nokogiri_parse(html[:html], html[:charset])
    liststage_html = doc.xpath("//div[@id='listStage']").inner_html
    liststage_doc  = HtmlParser.nokogiri_parse(liststage_html, html[:charset])
    liststage_doc.xpath("//a[@class='list-group-item box ']")
  end

  def _stage(node, charset)
    stage = {}
    stage[:url] = node.attribute('href').text

    doc = HtmlParser.nokogiri_parse(node.inner_html, charset)
    stage[:stage]   = doc.xpath("//p[@class='stage']").text
    stage[:group]   = doc.xpath("//p[@class='group']").text
    stage[:theater] = doc.xpath("//p[@class='theater']").inner_text

    period = doc.xpath("//p[@class='period']").inner_html
    dates = _dates(period)
    stage[:startdate] = dates[:startdate]
    stage[:enddate]   = dates[:enddate]
    stage
  end

  def _dates(str)
    period = str.gsub(/<i (.*?)<\/i>/, "").gsub(/<span (.*?)<\/span>/, "")
    str = period.split("～")
    { startdate: _date(str[0]), enddate: _date(str[1]) }
  end

  def _date(str)
    d = str.strip.match(/([0-9]{4})\/([0-9]{2})\/([0-9]{2})/)
    "%04d-%02d-%02d"%[ d[1].to_i, d[2].to_i, d[3].to_i ]
  end
end

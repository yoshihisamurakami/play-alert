
#
# 1件の舞台情報のページに
#  劇団ページURL,  劇団名
# の情報があるので、それを拾ってくる
#
class StageHtmlParser
  
  class << self
    def parse( url )
      html   = HtmlParser.html( url )
      _troup_info( html ) 
    end

    private
      def _troup_info( html )
        doc = HtmlParser.nokogiri_parse(html[:html], html[:charset])
        troup_html = doc.xpath("//p[@class='group']").inner_html
        troup_doc = HtmlParser.nokogiri_parse( troup_html, html[:charset] )
        { url: troup_doc.at('//a').[]('href'),
          name: troup_doc.at('//a').text }
      end
  end
end
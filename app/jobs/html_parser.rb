require 'open-uri'

class HtmlParser
  DEFAULT_CHARSET = 'utf-8'
  
  class << self
    def html( url )
      charset = nil
      html = open( url ) do |f|
        charset = (f.class == 'Tempfile') ? f.charset : DEFAULT_CHARSET
        f.read
      end
      { html: html, charset: charset }
    end
    
    def nokogiri_parse(html, charset)
      Nokogiri::HTML.parse(html, nil, charset)
    end
  end
end

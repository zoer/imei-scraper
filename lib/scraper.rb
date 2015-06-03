$:.unshift File.dirname(__FILE__)

require "nokogiri"
require "uri"
require "net/http"
require "date"

#
# Scrapes warranty infomation about Apple devices by IMEI number
#
module Scraper
  module Parser
    autoload :Base, "scraper/parser/base"
    autoload :ImeiPage, "scraper/parser/imei_page"
  end
  module Crawler
    autoload :AppleImei, "scraper/crawler/apple_imei"
  end
  autoload :ImeiReport, "scraper/imei_report"
end

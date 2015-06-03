require 'webmock/rspec'
require_relative "../lib/scraper"
require "byebug"

WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

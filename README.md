# IMEI Scraper

[![Build Status](https://travis-ci.org/zoer/imei-scraper.svg)](https://travis-ci.org/zoer/imei-scraper)
[![Code Climate](https://codeclimate.com/github/zoer/imei-scraper/badges/gpa.svg)](https://codeclimate.com/github/zoer/imei-scraper)
[![Heroku app](https://camo.githubusercontent.com/be46aee4f8d55e322c3e7db60ea23a4deb5427c9/68747470733a2f2f6865726f6b752d62616467652e6865726f6b756170702e636f6d2f3f6170703d6865726f6b752d6261646765)](http://imei-scraper.herokuapp.com)

Scrapes warranty infomation about Apple devices by IMEI number.

## Installation

```shell
$ git clone https://github.com/zoer/imei-scraper
$ cd imei-sraper
$ bundle install
```


## Usage

### Use with a browser

[Quick demo on heroku](http://imei-scraper.herokuapp.com)

or You can run it by self:

```shell
$ bundle exec rails s
$ open http://localhost:3000
```

### Use from the command line

```shell
$ bin/imei 123456789012347 013977000323877 013896000639712
[
  {
    "status": 200,
    "imei": "123456789012347",
    "result": {
      "imei": "123456789012347",
      "not_activated": true
    }
  },
  {
    "status": 200,
    "imei": "013977000323877",
    "result": {
      "phone_has_coverage": true,
      "hardware_has_coverage": true,
      "hardware_support_coverage": "PD",
      "has_active_app": false,
      "app_eligible": false,
      "ppi_eligible": false,
      "product_type": "iPhone",
      "days_since_dop": "299",
      "has_tech_tool": false,
      "phone_expiration": "2016-08-10",
      "hardware_expiration": "2016-08-10",
      "image": "https://km.support.apple.com.edgekey.net/kb/securedImage.jsp?configcode=FFHN&size=72x72",
      "product_name": "iPhone 5c",
      "imei": "013977000323877"
    }
  },
...
]
```

### Use IRB

```ruby
$ irb
irb(main):001:0> require_relative "lib/scraper"
=> true

irb(main):002:0> r = Scraper::ImeiReport.new
=> #<Scraper::ImeiReport:0x007f024c893c08 @crawler=#<Scraper::Crawler::AppleImei:0x007f024c88d3d0>, @parser=#<Scraper::Parser::ImeiPage:0x007f024c868cd8 @data={}, @doc=nil>>

irb(main):003:0> r.get("013977000323877")
=> {:status=>200, :imei=>"013977000323877", :result=>{:phone_has_coverage=>true, :hardware_has_coverage=>true, :hardware_support_coverage=>"PD", :has_active_app=>false, :app_eligible=>false, :ppi_eligible=>false, :product_type=>"iPhone", :days_since_dop=>"299", :has_tech_tool=>false, :phone_expiration=>"2016-08-10", :hardware_expiration=>"2016-08-10", :image=>"https://km.support.apple.com.edgekey.net/kb/securedImage.jsp?configcode=FFHN&size=72x72", :product_name=>"iPhone 5c", :imei=>"013977000323877"}}
```

### Documentation

Please see documentaion one the  website http://zoer.github.io/imei-scraper/

License

## License

ImeiScraper is released under the [MIT License](http://www.opensource.org/licenses/MIT).

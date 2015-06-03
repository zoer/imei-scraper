module Scraper
  module Crawler
    #
    # AppleImei controls request to the apple site
    #
    class AppleImei
      URL = URI("https://selfsolve.apple.com/wcResults.do")

      USER_AGENT = \
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:38.0) " \
        "Gecko/20100101 Firefox/38.0"

      #
      # Make request with the given IMEI number
      #
      # @param [String] imei
      #
      # @return [String] returns response page body
      #
      def request_imei(imei)
        req = ::Net::HTTP::Post.new(URL, "User-Agent" => USER_AGENT)
        req.set_form_data(sn: imei, num: number)
        @res = ::Net::HTTP.start(URL.hostname, URL.port, use_ssl: true) do |http|
          http.request(req)
        end
      end

      #
      # Page content
      #
      # @return [String] returns content of the page
      #
      def page
        @res ? @res.body : ""
      end

      #
      # HTTP response code
      #
      # @return [Integer]
      #
      def status_code
        @res ? @res.code.to_i : 0
      end

      #
      # Random number
      #
      # @note We need that number to do the correct imei request.
      #
      # @return [Integer] returns the random integer
      #   between 1000 and 3000
      #
      def number
        rand(1000..3000)
      end

      #
      # Is content able for parsing?
      #
      # @return [Boolean] returns +true+ if content of the page
      #   parasble, otherwise +false+
      #
      def parsable?
        status_code.between?(200, 299) && !!/html/i.match(page)
      end
    end
  end
end

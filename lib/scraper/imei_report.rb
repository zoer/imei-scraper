module Scraper
  #
  # ImeiReport class which comunicates with parser and crawler
  #
  class ImeiReport
    #
    # Initialize
    #
    def initialize
      @crawler = Crawler::AppleImei.new
      @parser = Parser::ImeiPage.new
    end

    #
    # Get IMEI info
    #
    # @param [String] imei
    #
    # @return [Hash] returns parsed info about the IMEI
    #
    def get(imei)
      ret = {imei: imei, valid: valid?(imei)}
      return ret unless ret[:valid]

      @crawler.request_imei(imei)
      ret[:status] = @crawler.status_code
      ret[:result] = @parser.parse(@crawler.page) if @crawler.parsable?
      ret
    end

    #
    # Validate IMEI number
    #
    # @param [Integer, String] imei
    #
    # @return returns result of IMEI validation
    #
    def valid?(imei)
      imei = imei.to_s
      return false unless /\A\d{15}\z/ =~ imei

      nums = imei[0, 14].split("").map(&:to_i)
        .each_with_index
        .map { |n, i| (i % 2).zero? ? n : (n*2).to_s.split("") }
      sum = [nums].flatten.map(&:to_i).reduce(&:+)
      10 - sum % 10 == imei[-1].to_i
    end
  end
end

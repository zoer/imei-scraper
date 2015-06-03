module Scraper
  module Parser
    #
    # Base class which controls the base parser operations
    #
    class Base
      # Parsed IMEI info
      attr_reader :data

      #
      # Parse the page
      #
      # @param [String] page HTML content with the
      #   IMEI information
      #
      # @return [Hash] returns parsed IMEI info
      #
      def parse(page)
        @page = page
        reset_data
        methods.grep(/^parse_/).each { |m| send(m) }

        after_parse
        data
      end

      #
      # Nokogiri document
      #
      # @return [Nokogiri::HTML::Document]
      #
      def doc
        @doc ||= Nokogiri::HTML(@page)
      end
    end
  end
end

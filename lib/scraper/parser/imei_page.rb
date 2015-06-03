module Scraper
  module Parser
    #
    # ImeiPage class which parse the site page body
    #
    class ImeiPage < Base
      PHONE_EXPIRATION_PATTERN = \
        /displayPHSupportInfo.*Estimated\s+Expiration\s+Date:\s+(?<date>[^<]+)/
      HARDWARE_EXPIRATION_PATTERN = \
        /displayHWSupportInfo.*Estimated\s+Expiration\s+Date:\s+(?<date>[^<]+)/
      JSON_PATTERN = /jsonObj\s*=\s*{(?<obj>[^}]+)}/m
      JSON_GROUP_PATTERN = /'([^']+)'\s*:\s*'?([^,]+?)'?[\n,]/
      IMAGE_URL_PATTERN = /displayProductInfo.*(?<image>http[^'"]+)/
      PRODUCT_NAME_PATTERN = /displayProductInfo.*?'.*?'.*?'(?<name>[^']+)/
      IMEI_PATTERN = /displayProductInfo.*?'.*?'.*?'.*?'.*?'(?<imei>\d{15})/
      NOT_ACTIVATED_PATTERN = /iPhone\s+has\s+not\s+been\s+activated/

      # JSON keys aliases
      KEY_ALIASES = {
        "phoneSupportHasCoverage" => :phone_has_coverage,
        "hwSupportHasCoverage" => :hardware_has_coverage,
        "hwSupportCoverageValue" => :hardware_support_coverage,
        "hasActiveAPP" => :has_active_app,
        "isAPPEligible" => :app_eligible,
        "isPPIEligible" => :ppi_eligible,
        "productType" => :product_type,
        "numDaysSinceDOP" => :days_since_dop,
        "hasTechToolDownload" => :has_tech_tool
      }

      def initialize
        reset_data
      end

      #
      # Reset the data object
      #
      def reset_data
        @data = {}
        @doc = nil
      end

      #
      # Parse JSON object in the script content
      #
      def parse_json
        matchers = JSON_PATTERN.match(script_content)
        return unless matchers

        matchers[:obj].scan(JSON_GROUP_PATTERN).each do |group|
          @data[json_key_alias(group.first)] = eval_json_value(group.last)
        end
      end

      #
      # Parse phone expiration
      #
      def parse_phone_expiration
        expiration_date_parse(:phone)
      end

      #
      # Parse hardware expiration
      #
      def parse_hardware_expiration
        expiration_date_parse(:hardware)
      end

      #
      # Parse product image url
      #
      def parse_image_url
        matchers = IMAGE_URL_PATTERN.match(script_content)
        return unless matchers

        @data[:image] = matchers[:image]
      end

      #
      # Parse product name
      #
      def parse_product_name
        matchers = PRODUCT_NAME_PATTERN.match(script_content)
        return unless matchers

        @data[:product_name] = matchers[:name]
      end

      #
      # Parse IMEI number
      #
      def parse_imei
        matchers = IMEI_PATTERN.match(script_content)
        return unless matchers

        @data[:imei] = matchers[:imei]
      end

      #
      # Parse info when phone is not activated
      #
      def parse_not_activated
        matchers = NOT_ACTIVATED_PATTERN.match(script_content)
        return unless matchers

        @data[:not_activated] = true
      end

      #
      # Cleanup after data is parsed
      #
      def after_parse
        # We don't need additional info, if device is not activated
        if @data[:not_activated]
          @data.delete_if { |k,v| !%i(not_activated imei).include?(k) }
        end

        @data = {error: "Has no information"} unless @data[:imei]

        convert_days_since_dop
      end

      private

      #
      # Script tag content
      #
      # @return [String] returns content of the script tag
      #   with the IMEI information
      #
      def script_content
        node = doc.xpath("//script[contains(text(),'new WCPage')]")
        node.empty? ? "" : node.text
      end

      #
      # Parse and store the expiration date
      #
      def expiration_date_parse(subject)
        pattern = self.class.const_get("#{subject.upcase}_EXPIRATION_PATTERN")
        matchers = pattern.match(script_content)
        @data[:"#{subject}_expiration"] = matchers ?
          Date.parse(matchers[:date]).to_s : "Expired"
      rescue ArgumentError
      end

      #
      # Evaluate JSON value
      #
      # @return [String, Boolean]
      #
      def eval_json_value(value)
        return eval(value) if %w(true false).include?(value)
        return value
      end

      #
      # Resolve json key alias
      #
      # @return [String] returns resolved alias if it exists,
      #   otherwise returns key back
      #
      def json_key_alias(name)
        KEY_ALIASES[name] || name
      end

      #
      # Convert days_since_dop to purchase_date
      #
      def convert_days_since_dop
        return unless @data[:days_since_dop] =~ /\A\d+\z/

        @data[:purchase_date] = \
          (Date.today - @data.delete(:days_since_dop).to_i).to_s
      end
    end
  end
end

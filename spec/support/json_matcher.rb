RSpec::Matchers.define :match_imei_json do |imei|
  fixture = File.read \
    File.expand_path("../../fixtures/json/#{imei}.json", __FILE__)

  # Parse JSON and symbolize_keys
  expected = Hash[JSON.parse(fixture).map{|(k,v)| [k.to_sym,v]}]

  # Convert days_since_dop to dop_date
  if expected[:days_since_dop]
    expected[:purchase_date] = \
      (Date.today - expected.delete(:days_since_dop).to_i).to_s
  end

  match { |actual| actual == expected }

  failure_message do |actual|
    "expected that #{expected} would be equal to #{actual}"
  end
end

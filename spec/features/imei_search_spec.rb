require "rails_helper"

RSpec.describe "Search for IMEI info", :js do
  let(:imei) { "013977000323877" }
  let(:body) { fixture("active_#{imei}") }
  let(:result) do
    JSON.parse(find(:css, "#result").text).deep_symbolize_keys
  end

  before(:example) do
    stub_request(:post, Scraper::Crawler::AppleImei::URL.to_s)
      .to_return(body: body)
  end

  it "IMEI valid number search" do
    visit "/"
    fill_in :search, with: imei
    find(:css, "#go").click

    expect(result).to include({
      status: 200,
      imei: "013977000323877",
    })
    expect(result[:result]).to match_imei_json(imei)
  end
end

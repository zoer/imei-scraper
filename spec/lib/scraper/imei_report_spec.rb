require "spec_helper"

RSpec.describe Scraper::ImeiReport do
  let(:report) { described_class.new }
  let(:imei) { "013977000323877" }
  let(:data) { { status: 200, imei: imei } }
  let(:result) { report.get(imei) }

  describe "#get" do
    context "when IMEI valid" do
      before(:example) do
        stub_request(:post, Scraper::Crawler::AppleImei::URL.to_s)
          .to_return(body: fixture("active_#{imei}"))
      end

      it "should returns a parsed imei info" do
        expect(result).to include data
        expect(result[:result]).to match_imei_json(imei)
      end
    end

    context "when IMEI is not valid" do
      let(:imei) { "foo" }

      it { expect(result).to eq(imei: imei, valid: false) }
    end
  end

  it "#valid?" do
    expect(report.valid?("123456789012347")).to eq true
    expect(report.valid?("013977000323877")).to eq true
    expect(report.valid?("013896000639712")).to eq true
    expect(report.valid?("123456789012348")).to eq false
    expect(report.valid?("12345678901234")).to eq false
    expect(report.valid?(nil)).to eq false
  end
end

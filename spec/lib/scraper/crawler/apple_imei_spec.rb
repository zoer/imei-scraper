require "spec_helper"

RSpec.describe Scraper::Crawler::AppleImei do
  let(:crawler) { described_class.new }
  let(:number) { 112 }

  describe "#request_imei" do
    let(:body) { "foo" }
    let(:imei) { "123456789012347" }

    before(:example) do
      stub_request(:post, described_class::URL.to_s).to_return(body: body)
      allow_any_instance_of(described_class).to receive(:number) { number }
      crawler.request_imei(imei)
    end

    it "should sends a POST request" do
      expect(crawler.status_code).to eq 200
      expect(crawler.page).to eq body
      expect(WebMock).to \
        have_requested(:post, described_class::URL.to_s)
        .with(
          body: "sn=#{imei}&num=#{number}",
          headers: {"User-Agent" => described_class::USER_AGENT}
        )
    end
  end

  describe "parsable?" do
    let(:page) { "<HTML> ..." }
    let(:status_code) { 200 }

    before(:example) do
      allow(crawler).to receive(:page) { page }
      allow(crawler).to receive(:status_code) { status_code }
    end

    it "when response status is OK and page has HTML" do
      expect(crawler.parsable?).to eq true
    end

    context "when response code isn't between 200..299" do
      let(:status_code) { 404 }

      it { expect(crawler.parsable?).to eq false }
    end

    context "when page has no valid HTML" do
      let(:page) { "foo" }

      it { expect(crawler.parsable?).to eq false }
    end
  end
end

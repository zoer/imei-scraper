require "spec_helper"

RSpec.describe Scraper::Parser::ImeiPage do
  let(:parser) { described_class.new }
  let(:data) { parser.data }

  before(:example) { parser.parse(page) }

  context "with the active IMEI number" do
    let(:imei) { "013977000323877" }
    let(:page) { fixture("active_#{imei}") }

    it { expect(data).to match_imei_json(imei) }
  end

  context "with the expired IMEI number" do
    let(:imei) { "013896000639712" }
    let(:page) { fixture("expired_#{imei}") }

    it { expect(data).to match_imei_json(imei) }
  end

  context "with the not activated IMEI number" do
    let(:imei) { "123456789012347" }
    let(:page) { fixture("not_activated_#{imei}") }

    it { expect(data).to match_imei_json(imei) }
  end

  context "with the invalid IMEI number" do
    let(:page) { fixture("invalid") }

    it { expect(data).to match_imei_json("invalid") }
  end
end

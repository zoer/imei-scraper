require "rails_helper"

RSpec.describe ImeiController do
  describe "#show action" do
    it "should render #show template" do
      get :show
      expect(response).to render_template(:show)
      expect(response).to render_template(layout: "application")
      expect(response).to be_success
    end
  end

  describe "#search action" do
    let(:imei) { "123456789012347" }
    let(:result) { JSON.parse(response.body).deep_symbolize_keys }
    let(:body) { fixture("not_activated_#{imei}") }

    before(:example) do
      stub_request(:post, Scraper::Crawler::AppleImei::URL.to_s)
        .to_return(body: body)
    end

    it "search for imei info" do
      get :search, imei: imei, format: "json"
      expect(response).to be_success
      expect(result).to include({status: 200, imei: imei})
      expect(result[:result]).to match_imei_json(imei)
    end

    it "incorrect format" do
      expect do
        get :search, imei: imei
      end.to raise_error ActionController::UnknownFormat
    end
  end
end

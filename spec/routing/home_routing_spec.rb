require "rails_helper"

RSpec.describe ImeiController do
  it "#show" do
    expect(get: "/").to route_to("imei#show")
  end

  it "#search" do
    expect(get: "/search/1").to route_to("imei#search", imei: "1")
  end
end

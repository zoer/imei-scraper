Rails.application.routes.draw do
  get "/search/:imei", to: "imei#search"
  root to: "imei#show"
end

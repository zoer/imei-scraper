class ImeiController < ApplicationController
  before_action :init_report, only: %i(search)

  #
  # Display the form
  #
  def show
  end

  #
  # Search for IMEI number info
  #
  def search
    respond_to do |format|
      format.json { render json: @info.get(params[:imei]) }
    end
  end

  private

  #
  # Load IMEI report servise
  #
  def init_report
    @info = Scraper::ImeiReport.new
  end
end

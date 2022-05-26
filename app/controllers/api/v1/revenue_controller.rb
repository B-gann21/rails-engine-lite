class Api::V1::RevenueController < ApplicationController
  def index
    if params[:start] && params[:end]
      revenue = Merchant.total_revenue_within_date(params[:start], params[:end])
      require 'pry'; binding.pry  
      render json: RevenueSerializer.total_revenue(revenue)

    elsif Time.parse(params[:start]) > Time.parse(params[:end])
      render json: {error: 'start date can not be after end date'}, status: 400

    else
      render json: {error: 'invalid start date or end date'}, status: 400
    end
  end
end

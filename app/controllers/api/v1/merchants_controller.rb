class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render status: 404
    end
  end

  def find
    if params[:name] != '' && params[:name]
      render json: Merchant.find_by_name(params[:name])
    else
      render status: 400
    end
  end
end

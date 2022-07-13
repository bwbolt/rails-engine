class Api::V1::MerchantItemsController < ApplicationController
  def index
    if Merchant.exists?(params[:merchant_id])
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      # render status: 404
      message = { error: 'Merchant does not exist' }
      render json: message.to_json, status: 404

    end
  end
end

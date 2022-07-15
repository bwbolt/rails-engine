class Api::V1::ItemMerchantController < ApplicationController
  def index
    if Item.exists?(params[:item_id])
      merchant = Item.find(params[:item_id]).merchant
      render json: MerchantSerializer.new(merchant)
    else
      render status: 404
    end
  end
end

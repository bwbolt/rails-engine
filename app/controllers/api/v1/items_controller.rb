class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render status: 404
    end
  end

  def update
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      item.update(item_params)
      if item.save
        render json: ItemSerializer.new(item)
      else
        render status: 404
      end
    else
      render status: 404
    end
  end

  def destroy
    if Item.exists?(params[:id])
      Item.destroy(params[:id])
    else
      render status: 404
    end
  end

  def find_all
    if params[:name] && params[:min_price] && params[:max_price]
      render status: 404
    elsif params[:name]
      if params[:name] == ''
        render status: 400
      else
        render json: ItemSerializer.new(Item.find_all_name(params[:name]))
      end
    elsif params[:min_price] && params[:max_price]
      render json: ItemSerializer.new(Item.find_all_range(params[:min_price], params[:max_price]))
    elsif params[:min_price]
      render json: ItemSerializer.new(Item.find_all_min_price(params[:min_price]))
    elsif params[:max_price]
      render json: ItemSerializer.new(Item.find_all_max_price(params[:max_price]))
    else
      render status: 400
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end

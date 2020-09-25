class SupermarketsController < ApplicationController

  # GET /supermarkets
  def list_all
    render json: Supermarket.all
  end

  # GET /supermarkets/:id
  def list_one
    render json: Supermarket.find(params[:id])
  end

  # DELETE /supermarkets/:id
  def remove
    Supermarket.find(params[:id]).destroy
  end

end

class ExtractsController < ApplicationController

  # GET /extracts
  def list_all
    response = []
    Extract.all.each do |extract|
      extract = JSON::parse(extract.to_json).merge("supermarket_name" => extract.supermarket.name)
      response << extract
    end
    render json: response
  end

  # GET /extracts/:id
  def list_one
    @extract = Extract.find(params[:id])
    render json: JSON::parse(@extract.to_json).merge("supermarket_name" => @extract.supermarket.name)
  end

  # GET /extracts/list_by_product/:id
  def list_by_product
    response =  Extract.where(product_id: params[:id]).with_supermarket_name
    render json: response
  end

  def list_by_category
    response = Extract.where(product_id: Category.find(params[:id]).products.pluck(product: :id))
      .with_supermarket_name
    render json: response
  end

  def list_by_date
    response = Extract.where("extracts.created_at LIKE ?", "%#{Date.parse(params[:date])}%")
      .with_supermarket_name
    render json: response
  end

  # POST /extracts
  def create
    render json: Extract.create!(extract_params)
  end

  # PATCH/PUT /extracts/1
  def update
    @extract.update!(extract_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extract
      @extract = Extract.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def extract_params
      params.require(:extract).permit(:event, :value, :quantity, :supermarket_id, :product_id)
    end
end

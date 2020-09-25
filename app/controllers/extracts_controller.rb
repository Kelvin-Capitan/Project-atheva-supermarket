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
    response = []
    Extract.where(product_id: params[:id]).each do |extract|
      extract = JSON::parse(extract.to_json).merge("supermarket_name" => extract.supermarket.name)
      response << extract
    end

    render json: response
  end

  def list_by_category
    response = []
    @ids = []
    Category.find(params[:id]).products.each do |prod|
      @ids << prod.id
    end
    Extract.where(product_id: @ids).each do |extract|
      extract = JSON::parse(extract.to_json).merge("supermarket_name" => extract.supermarket.name)
      response << extract
    end
    render json: response
  end

  def list_by_date
    response = []
    puts ""
    @date = Date.parse(params[:date])
    puts @date
    Extract.where("extracts.created_at LIKE ?", "%#{@date}%").each do |extract|
      extract = JSON::parse(extract.to_json).merge("supermarket_name" => extract.supermarket.name)
      response << extract
    end
    render json: response
  end

  # POST /extracts
  def create
    @extract = Extract.new(extract_params)

    if @extract.save
      render json: @extract, status: :created, location: @extract
    else
      render json: @extract.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /extracts/1
  def update
    if @extract.update(extract_params)
      render json: @extract
    else
      render json: @extract.errors, status: :unprocessable_entity
    end
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

class CategoriesController < ApplicationController

  # GET /categories
  def list_all
    response = []
    Category.all.each do |category|
      category = JSON::parse(category.to_json).merge("supermarket_name" => category.supermarket.name)
      response << category
    end
    render json: response
  end

  # GET /categories/:id
  def list_one
    @category = Category.find(params[:id])
    render json: JSON::parse(@category.to_json).merge("supermarket_name" => @category.supermarket.name).to_json
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH /categories/:id
  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:id
  def remove
    Category.find(params[:id]).destroy
  end

  # DELETE /categories/remove_many
  def remove_many
    params[:remove_list].to_a.each do |id|
      Category.find(id).destroy
    end
  end

  private

    def category_params
      params.require(:category).permit(:name, :supermarket_id)
    end

end

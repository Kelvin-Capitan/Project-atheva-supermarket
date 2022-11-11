class CategoriesController < ApplicationController

  # GET /categories
  def list_all
    response = Category.with_supermarket_name
    render json: response
  end

  # GET /categories/:id
  def list_one
    @category = Category.find(params[:id])
    render json: @category.with_supermarket_name
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

  # DELETE /categories/remove/many
  def remove_many
    Category.where(id: params[:remove_list].to_a.pluck(:id)).destroy_all
  end

  private

    def category_params
      params.require(:category).permit(:name, :supermarket_id)
    end

end

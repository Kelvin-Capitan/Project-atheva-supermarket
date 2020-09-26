class ProductsController < ApplicationController

  # GET /products
  def list_all
    response = []
    Product.all.each do |prod|
      prod = JSON::parse(prod.to_json).merge("supermarket_name" => prod.category.supermarket.name)
      response << prod
    end
    render json: response
  end

  # GET /products/:id
  def list_one
    @product = Product.find(params[:id])
    render json: JSON::parse(@product.to_json).merge("supermarket_name" => @product.category.supermarket.name)
  end

  # PATCH /products/buy
  def buy
    @product = Product.new(product_params)

    #Verifica se já existe um produto com o mesmo nome
    if Product.find_by_name(@product.name) != nil
      @product = Product.find_by_name(@product.name)
      @product.quantity = (@product.quantity.to_i + params[:quantity])
    end

    #Verifica se já existe um produto com o mesmo codigo
    if Product.find_by_code(@product.code) != nil
      @product = Product.find_by_code(@product.code)
      @product.quantity = (@product.quantity.to_i + params[:quantity])
    end

    if @product.save

      #Atualiza a quantidade da categoria
      @category = Category.find(@product.category_id)
      @category.quantity = (@category.quantity.to_i + params[:quantity].to_i)
      @category.save

      #Atualiza o Saldo
      @supermarket = @product.category.supermarket
      @value = params[:quantity] * @product.price
      @supermarket.balance = (@supermarket.balance - @value)
      @supermarket.save

      #Cria o Extrato
      Extract.create!(event: "Compra de #{params[:quantity]} #{@product.name}",
                           value: (0 - @value),
                           quantity: (params[:quantity]),
                           supermarket_id: @product.category.supermarket.id,
                           product_id: @product.id)

      render json: JSON::parse(@product.to_json).merge("supermarket_name" => @product.category.supermarket.name), status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATH /products/sell
  def sell
    @product = Product.new(product_params)

    #Verifica se já existe um produto com o mesmo nome
    if Product.find_by_name(@product.name) != nil
      @product = Product.find_by_name(@product.name)
      @product.quantity = (@product.quantity.to_i - params[:quantity])
    end

    #Verifica se já existe um produto com o mesmo codigo
    if Product.find_by_code(@product.code) != nil
      @product = Product.find_by_code(@product.code)
      @product.quantity = (@product.quantity.to_i - params[:quantity])
    end

    if @product.save

      #Atualiza a quantidade da categoria
      @category = Category.find(@product.category_id)
      @category.quantity = (@category.quantity.to_i - params[:quantity].to_i)
      @category.save

      #Atualiza o saldo
      @supermarket = @product.category.supermarket
      @value = params[:quantity] * @product.price
      @supermarket.balance = (@supermarket.balance + @value)
      @supermarket.save

      #Cria o extrato
      Extract.create!(event: "Venda de #{params[:quantity]} #{@product.name}",
                      value: (@value),
                      quantity: (params[:quantity]),
                      supermarket_id: @product.category.supermarket.id,
                      product_id: @product.id)

      render json: JSON::parse(@product.to_json).merge("supermarket_name" => @product.category.supermarket.name), status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH /products/:id
  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      render json: JSON::parse(@product.to_json).merge("supermarket_name" => @product.category.supermarket.name)
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def remove
    Product.find(params[:id]).destroy
  end

  # DELETE /categories/remove/many
  def remove_many
    params[:remove_list].to_a.each do |id|
      Product.find(id).destroy
    end
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :quantity, :category_id, :code)
    end
end

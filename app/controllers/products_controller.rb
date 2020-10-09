class ProductsController < ApplicationController
  include Update

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

    #Verifica se já existe um produto com o mesmo nome codigo senão cria um novo
    if search_by_name_and_code(params[:name],params[:code],params[:quantity].to_i) == false
      @product = Product.new(product_params)
    end


    if @product.save

      #Atualiza a quantidade da categoria
      update_quantity(@product,params[:quantity].to_i)

      #Atualiza o Saldo
      update_balance(@product,params[:quantity].to_i)

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
    #Verifica se já existe um produto com o mesmo nome codigo senão cria um novo
    if search_by_name_and_code(params[:name],params[:code],params[:quantity].to_i) == false
      @product = Product.new(product_params)
    end

    if @product.save

      #Atualiza a quantidade da categoria
      update_quantity(@product,params[:quantity].to_i)

      #Atualiza o saldo
      update_balance(@product,params[:quantity].to_i)

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

    def search_by_name_and_code(name,code,quantity)
      #Verifica se já existe um produto com o mesmo nome
      if Product.find_by_name(name) != nil
        @product = Product.find_by_name(name)
        @product.quantity = (@product.quantity.to_i + quantity)
        return true
        #Verifica se já existe um produto com o mesmo codigo
        elsif Product.find_by_code(code) != nil
          @product = Product.find_by_code(code)
          @product.quantity = (@product.quantity.to_i + quantity)
          return true
      else
        return false
      end
    end

    def product_params
      params.require(:product).permit(:name, :price, :quantity, :category_id, :code)
    end
end

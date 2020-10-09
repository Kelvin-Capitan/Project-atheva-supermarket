module Update
  #Atualiza a quantidade de uma categoria
  def update_quantity(product,quantity)
    @category = Category.find(product.category_id)
    @category.quantity = (@category.quantity.to_i + quantity)
    @category.save
  end

  def update_balance(product,quantity)
    @supermarket = product.category.supermarket
    if quantity > 0
      @value = product.price * quantity
    else
      @value = product.price * -quantity
    end
    @supermarket.balance = (@supermarket.balance - @value)
    @supermarket.save
  end
end
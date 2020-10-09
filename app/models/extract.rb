class Extract < ApplicationRecord
  belongs_to :supermarket
  belongs_to :product

  validates_presence_of :supermarket_id, :product_id
  validates_associated :supermarket, :product

  validates_presence_of :event, message: " - deve ser preenchido"
  validates_presence_of :value, message: " - deve ser preenchido"
  validates_presence_of :quantity, message: " - deve ser preenchido"
end
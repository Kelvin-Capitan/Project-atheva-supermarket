class Product < ApplicationRecord

  scope :with_supermarket_name, -> { joins(:category => :supermarket).select("products.*, supermarkets.name as supermarket_name")}

  belongs_to :category
  has_many :extracts, dependent: :destroy

  validates_presence_of :category_id
  validates_associated :category

  validates_presence_of :name, message: " - deve ser preenchido"
  validates_presence_of :quantity, message: " - deve ser preenchido"
  validates_numericality_of :quantity, greater_than: 0,
                            message: " - deve ser uma quantidade maior que 0"
end

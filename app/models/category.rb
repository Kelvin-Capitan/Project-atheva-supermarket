class Category < ApplicationRecord
  belongs_to :supermarket
  has_many :products, dependent: :destroy

  scope :with_supermarket_name, -> { joins(:supermarket).select("categories.*, supermarket.name as supermarket_name")}

  validates_presence_of :supermarket_id
  validates_associated :supermarket

  validates_presence_of :name, message: " - deve ser preenchido"
  validates_presence_of :quantity, message: " - deve ser preenchido"
  validates_numericality_of :quantity, greater_than: 0,
                            message: " - deve ser uma quantidade maior que 0"
end

class Category < ApplicationRecord
  belongs_to :supermarket
  has_many :products, dependent: :destroy
end

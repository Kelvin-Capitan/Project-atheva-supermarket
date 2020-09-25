class Product < ApplicationRecord
  belongs_to :category
  has_many :extracts, dependent: :destroy
end

class Supermarket < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :extracts, dependent: :destroy
end

class Supermarket < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :extracts, dependent: :destroy

  validates_presence_of :name, message: " - deve ser preenchido"
  validates_presence_of :balance, message: " - deve ser preenchido"
end

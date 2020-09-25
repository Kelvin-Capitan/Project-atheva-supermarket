class CreateExtracts < ActiveRecord::Migration[6.0]
  def change
    create_table :extracts do |t|
      t.string :event
      t.float :value
      t.integer :quantity
      t.references :supermarket, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end

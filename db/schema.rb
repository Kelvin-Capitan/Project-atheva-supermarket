# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_25_205021) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.integer "supermarket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["supermarket_id"], name: "index_categories_on_supermarket_id"
  end

  create_table "extracts", force: :cascade do |t|
    t.string "event"
    t.float "value"
    t.integer "quantity"
    t.integer "supermarket_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_extracts_on_product_id"
    t.index ["supermarket_id"], name: "index_extracts_on_supermarket_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "quantity"
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "supermarkets", force: :cascade do |t|
    t.string "name"
    t.float "balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "categories", "supermarkets"
  add_foreign_key "extracts", "products"
  add_foreign_key "extracts", "supermarkets"
  add_foreign_key "products", "categories"
end

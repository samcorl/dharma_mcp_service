# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_08_30_010544) do
  create_table "agent_guidances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "context_type"
    t.string "category"
    t.text "conditions"
    t.text "guidance_text"
    t.text "suggested_actions"
    t.integer "priority"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "craft_instructions_pages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "difficulty_level"
    t.integer "estimated_time"
    t.text "materials_needed"
    t.text "steps"
    t.text "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "featured_artist_pages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "artist_name"
    t.text "bio"
    t.string "featured_image"
    t.text "portfolio_images"
    t.text "social_links"
    t.datetime "featured_until"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "frequently_asked_questions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.string "category"
    t.integer "display_order"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.bigint "parent_category_id"
    t.integer "display_order"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_category_id"], name: "index_product_categories_on_parent_category_id"
  end

  create_table "product_families", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.integer "display_order"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_recommendations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "primary_product_id", null: false
    t.bigint "recommended_product_id", null: false
    t.string "recommendation_type"
    t.decimal "confidence_score", precision: 10
    t.integer "display_order"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["primary_product_id"], name: "index_product_recommendations_on_primary_product_id"
    t.index ["recommended_product_id"], name: "index_product_recommendations_on_recommended_product_id"
  end

  create_table "product_variant_lists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "variant_type"
    t.string "variant_value"
    t.decimal "price_modifier", precision: 10
    t.string "sku_suffix"
    t.boolean "available"
    t.string "color_name"
    t.string "color_hex"
    t.string "size_label"
    t.integer "inventory_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variant_lists_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10
    t.string "sku"
    t.decimal "weight", precision: 10
    t.string "dimensions"
    t.boolean "availability"
    t.bigint "product_family_id", null: false
    t.bigint "product_category_id", null: false
    t.text "available_colors"
    t.text "available_sizes"
    t.string "fiber_content"
    t.string "weight_category"
    t.integer "yardage"
    t.text "care_instructions"
    t.string "skill_level_required"
    t.text "compatible_techniques"
    t.text "recommended_for"
    t.text "use_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["product_family_id"], name: "index_products_on_product_family_id"
  end

  create_table "project_ideas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "difficulty_level"
    t.string "project_type"
    t.integer "estimated_time"
    t.string "finished_size"
    t.text "instructions"
    t.text "images"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_idea_id", null: false
    t.bigint "product_id", null: false
    t.decimal "quantity_needed", precision: 10
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_project_products_on_product_id"
    t.index ["project_idea_id"], name: "index_project_products_on_project_idea_id"
  end

  create_table "support_articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "category"
    t.string "tags"
    t.integer "helpful_count"
    t.integer "view_count"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technique_guides", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "technique_type"
    t.string "difficulty_level"
    t.text "description"
    t.text "instructions"
    t.text "tools_needed"
    t.integer "time_estimate"
    t.string "video_url"
    t.text "images"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "product_categories", "product_categories", column: "parent_category_id"
  add_foreign_key "product_recommendations", "products", column: "primary_product_id"
  add_foreign_key "product_recommendations", "products", column: "recommended_product_id"
  add_foreign_key "product_variant_lists", "products"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products", "product_families"
  add_foreign_key "project_products", "products"
  add_foreign_key "project_products", "project_ideas"
end

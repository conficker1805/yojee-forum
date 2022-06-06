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

ActiveRecord::Schema.define(version: 2022_06_04_063309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.bigserial "topic_id", null: false
    t.text "content", null: false
    t.index ["id"], name: "index_posts_on_id"
    t.index ["topic_id"], name: "index_posts_on_topic_id"
  end

  create_table "posts_10k", id: :bigint, default: -> { "nextval('posts_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "topic_id", default: -> { "nextval('posts_topic_id_seq'::regclass)" }, null: false
    t.text "content", null: false
    t.index ["id"], name: "posts_10k_id_idx"
    t.index ["topic_id"], name: "posts_10k_topic_id_idx"
  end

  create_table "posts_20k", id: :bigint, default: -> { "nextval('posts_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "topic_id", default: -> { "nextval('posts_topic_id_seq'::regclass)" }, null: false
    t.text "content", null: false
    t.index ["id"], name: "posts_20k_id_idx"
    t.index ["topic_id"], name: "posts_20k_topic_id_idx"
  end

  create_table "posts_30k", id: :bigint, default: -> { "nextval('posts_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "topic_id", default: -> { "nextval('posts_topic_id_seq'::regclass)" }, null: false
    t.text "content", null: false
    t.index ["id"], name: "posts_30k_id_idx"
    t.index ["topic_id"], name: "posts_30k_topic_id_idx"
  end

  create_table "posts_40k", id: :bigint, default: -> { "nextval('posts_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "topic_id", default: -> { "nextval('posts_topic_id_seq'::regclass)" }, null: false
    t.text "content", null: false
    t.index ["id"], name: "posts_40k_id_idx"
    t.index ["topic_id"], name: "posts_40k_topic_id_idx"
  end

  create_table "posts_50k", id: :bigint, default: -> { "nextval('posts_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "topic_id", default: -> { "nextval('posts_topic_id_seq'::regclass)" }, null: false
    t.text "content", null: false
    t.index ["id"], name: "posts_50k_id_idx"
    t.index ["topic_id"], name: "posts_50k_topic_id_idx"
  end

  create_table "posts_over_50k", id: :bigint, default: -> { "nextval('posts_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "topic_id", default: -> { "nextval('posts_topic_id_seq'::regclass)" }, null: false
    t.text "content", null: false
    t.index ["id"], name: "posts_over_50k_id_idx"
    t.index ["topic_id"], name: "posts_over_50k_topic_id_idx"
  end

  create_table "quater_1_2022", id: :bigint, default: -> { "nextval('topics_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["id"], name: "quater_1_2022_id_idx"
  end

  create_table "quater_2_2022", id: :bigint, default: -> { "nextval('topics_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["id"], name: "quater_2_2022_id_idx"
  end

  create_table "quater_3_2022", id: :bigint, default: -> { "nextval('topics_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["id"], name: "quater_3_2022_id_idx"
  end

  create_table "quater_4_2022", id: :bigint, default: -> { "nextval('topics_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["id"], name: "quater_4_2022_id_idx"
  end

  create_table "questions", force: :cascade do |t|
    t.string "content", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id"], name: "index_questions_on_topic_id"
  end

  create_table "topics", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.string "title", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["id"], name: "index_topics_on_id"
  end

end

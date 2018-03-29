# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180329132514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "cards", force: :cascade do |t|
    t.citext "name"
    t.integer "cost"
    t.string "attack"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.citext "set"
    t.index ["name"], name: "index_cards_on_name"
  end

  create_table "competitors", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_competitors_on_game_id"
    t.index ["player_id"], name: "index_competitors_on_player_id"
  end

  create_table "decks", force: :cascade do |t|
    t.bigint "game_id"
    t.integer "draw", array: true
    t.integer "discard", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "competitor_id"
    t.index ["competitor_id"], name: "index_decks_on_competitor_id"
    t.index ["game_id"], name: "index_decks_on_game_id"
  end

  create_table "game_cards", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "card_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_game_cards_on_card_id"
    t.index ["game_id"], name: "index_game_cards_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "competitors", "games"
  add_foreign_key "competitors", "players"
  add_foreign_key "decks", "games"
  add_foreign_key "game_cards", "cards"
  add_foreign_key "game_cards", "games"
end

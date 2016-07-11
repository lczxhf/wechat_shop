# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160710154204) do

  create_table "gzh_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.string   "appid"
    t.string   "token"
    t.string   "refresh_token"
    t.boolean  "del",           default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["user_id"], name: "index_gzh_configs_on_user_id", using: :btree
  end

  create_table "gzh_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "gzh_config_id"
    t.integer  "user_id"
    t.string   "nickname"
    t.string   "headimgurl"
    t.integer  "service_type"
    t.integer  "verify_type"
    t.string   "alias"
    t.string   "user_name"
    t.string   "qrcode_url"
    t.boolean  "open_store",    default: false
    t.boolean  "open_scan",     default: false
    t.boolean  "open_pay",      default: false
    t.boolean  "open_card",     default: false
    t.boolean  "open_shake",    default: false
    t.boolean  "del",           default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["gzh_config_id"], name: "index_gzh_infos_on_gzh_config_id", using: :btree
    t.index ["user_id"], name: "index_gzh_infos_on_user_id", using: :btree
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "product_id"
    t.integer  "member_id"
    t.string   "path"
    t.boolean  "del",        default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["member_id"], name: "index_images_on_member_id", using: :btree
    t.index ["product_id"], name: "index_images_on_product_id", using: :btree
  end

  create_table "level_distributions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "product_id"
    t.decimal  "cost",                  precision: 10
    t.float    "discount",   limit: 24
    t.boolean  "del",                                  default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "level"
    t.index ["product_id"], name: "index_level_distributions_on_product_id", using: :btree
  end

  create_table "member_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "parent_member_id"
    t.integer  "child_member_id"
    t.integer  "level"
    t.boolean  "del",              default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "gzh_config_id"
    t.string   "openid"
    t.string   "wechat_number"
    t.integer  "phone"
    t.boolean  "del",            default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "nickname"
    t.boolean  "sex"
    t.string   "province"
    t.string   "city"
    t.string   "country"
    t.string   "headimgurl"
    t.string   "language"
    t.string   "subscribe_time"
    t.string   "remark"
    t.index ["gzh_config_id"], name: "index_members_on_gzh_config_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "member_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "mark"
    t.integer  "stock"
    t.text     "introduction", limit: 65535
    t.decimal  "postage",                    precision: 10
    t.decimal  "price",                      precision: 10
    t.decimal  "cost",                       precision: 10
    t.boolean  "show_stock"
    t.boolean  "show_price"
    t.boolean  "del",                                       default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.boolean  "is_threshold"
    t.index ["member_id"], name: "index_products_on_member_id", using: :btree
    t.index ["user_id"], name: "index_products_on_user_id", using: :btree
  end

  create_table "qrcode_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "image_id"
    t.integer  "member_id"
    t.integer  "product_id"
    t.string   "path"
    t.string   "tag"
    t.boolean  "del",        default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["image_id"], name: "index_qrcode_images_on_image_id", using: :btree
    t.index ["member_id"], name: "index_qrcode_images_on_member_id", using: :btree
    t.index ["product_id"], name: "index_qrcode_images_on_product_id", using: :btree
  end

  create_table "share_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "product_id"
    t.integer  "share_record_id"
    t.boolean  "del",             default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["product_id"], name: "index_share_products_on_product_id", using: :btree
    t.index ["share_record_id"], name: "index_share_products_on_share_record_id", using: :btree
  end

  create_table "share_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "from_member_id"
    t.integer  "to_member_id"
    t.string   "qrcode"
    t.integer  "level"
    t.integer  "status",         default: 0
    t.boolean  "del",            default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "user_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "u_type",     default: 0
    t.boolean  "del",        default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "openid"
    t.boolean  "status",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end

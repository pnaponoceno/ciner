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

ActiveRecord::Schema.define(version: 2018_07_02_061848) do

  create_table "age_ranges", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "link"
    t.string "image"
    t.boolean "visible"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["deleted_at"], name: "index_banners_on_deleted_at"
  end

  create_table "broadcast_broadcastables", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "broadcastable_type"
    t.integer "broadcastable_id"
    t.integer "broadcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_broadcast_broadcastables_on_deleted_at"
  end

  create_table "broadcast_images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "broadcast_id"
    t.string "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broadcast_professionals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "broadcast_id"
    t.bigint "professional_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broadcasts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "content"
    t.boolean "spoiler", default: false
    t.boolean "featured", default: false
    t.integer "likes_count", default: 0
    t.integer "dislikes_count", default: 0
    t.integer "comments_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.text "more"
    t.string "video"
    t.date "broadcast_date"
    t.string "source"
    t.string "subtitle"
    t.boolean "movie_content", default: false
    t.boolean "serie_content", default: false
    t.boolean "celebrity_content", default: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_broadcasts_on_deleted_at"
    t.index ["user_id"], name: "index_broadcasts_on_user_id"
  end

  create_table "ciner_production_countries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ciner_production_id"
    t.bigint "country_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ciner_production_id"], name: "index_ciner_production_countries_on_ciner_production_id"
    t.index ["country_id"], name: "index_ciner_production_countries_on_country_id"
    t.index ["deleted_at"], name: "index_ciner_production_countries_on_deleted_at"
  end

  create_table "ciner_production_film_production_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ciner_production_id"
    t.bigint "film_production_category_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ciner_production_id"], name: "cp_index_on_cp"
    t.index ["film_production_category_id"], name: "fpc_index_on_cp"
  end

  create_table "ciner_production_professionals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ciner_production_id"
    t.bigint "user_id"
    t.bigint "curriculum_function_id"
    t.string "observation"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ciner_production_id"], name: "index_ciner_production_professionals_on_ciner_production_id"
    t.index ["curriculum_function_id"], name: "index_ciner_production_professionals_on_curriculum_function_id"
    t.index ["deleted_at"], name: "index_ciner_production_professionals_on_deleted_at"
    t.index ["user_id"], name: "index_ciner_production_professionals_on_user_id"
  end

  create_table "ciner_production_videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "ciner_production_id"
    t.string "video"
    t.integer "season"
    t.integer "episode"
    t.string "observation"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ciner_production_id"], name: "index_ciner_production_videos_on_ciner_production_id"
    t.index ["deleted_at"], name: "index_ciner_production_videos_on_deleted_at"
  end

  create_table "ciner_productions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "original_title"
    t.string "title"
    t.integer "year"
    t.string "length"
    t.text "synopsis"
    t.date "release"
    t.date "brazilian_release"
    t.string "cover"
    t.text "omdb_genre"
    t.text "omdb_rated"
    t.text "trailer"
    t.string "countries"
    t.boolean "playing"
    t.boolean "playing_soon"
    t.boolean "available_netflix"
    t.boolean "available_amazon"
    t.integer "comments_count"
    t.integer "production_type"
    t.integer "status"
    t.integer "likes_count", default: 0
    t.integer "dislikes_count", default: 0
    t.bigint "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "age_range_id"
    t.index ["age_range_id"], name: "index_ciner_productions_on_age_range_id"
    t.index ["deleted_at"], name: "index_ciner_productions_on_deleted_at"
    t.index ["user_id"], name: "index_ciner_productions_on_user_id"
  end

  create_table "cities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "ckeditor_assets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.text "content"
    t.integer "status", default: 1
    t.integer "origin", default: 2
    t.boolean "spoiler", default: false
    t.boolean "featured", default: false
    t.integer "likes_count", default: 0
    t.integer "dislikes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "subject"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "acronym"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "critics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "filmable_type"
    t.integer "filmable_id"
    t.text "content"
    t.integer "rating"
    t.integer "filmable_release_year"
    t.integer "status", default: 2
    t.integer "origin", default: 2
    t.boolean "spoiler", default: false
    t.boolean "featured", default: false
    t.boolean "quick", default: false
    t.integer "likes_count", default: 0
    t.integer "dislikes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_critics_on_deleted_at"
    t.index ["filmable_type", "filmable_id"], name: "index_critics_on_filmable_type_and_filmable_id"
    t.index ["user_id"], name: "index_critics_on_user_id"
  end

  create_table "curriculum_audios", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "curriculum_id"
    t.string "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_id"], name: "index_curriculum_audios_on_curriculum_id"
  end

  create_table "curriculum_curriculum_functions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "curriculum_id"
    t.bigint "curriculum_function_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_function_id"], name: "index_curriculum_curriculum_functions_on_curriculum_function_id"
    t.index ["curriculum_id"], name: "index_curriculum_curriculum_functions_on_curriculum_id"
  end

  create_table "curriculum_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "curriculum_id"
    t.string "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_id"], name: "index_curriculum_files_on_curriculum_id"
  end

  create_table "curriculum_functions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "general"
  end

  create_table "curriculum_photos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "curriculum_id"
    t.string "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_id"], name: "index_curriculum_photos_on_curriculum_id"
  end

  create_table "curriculum_videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "curriculum_id"
    t.string "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_id"], name: "index_curriculum_videos_on_curriculum_id"
  end

  create_table "curriculums", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "play_name"
    t.string "avatar"
    t.text "biography"
    t.integer "user_id"
    t.integer "mannequin"
    t.float "height"
    t.integer "ethnicity"
    t.boolean "drt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "awards"
    t.string "jobs"
    t.index ["user_id"], name: "index_curriculums_on_user_id"
  end

  create_table "delates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "location"
    t.string "status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_delates_on_user_id"
  end

  create_table "event_images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "event_id"
    t.string "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.date "event_date"
    t.time "start_time"
    t.time "end_time"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured", default: false
    t.date "end_date"
    t.string "cover"
    t.string "place"
    t.text "more"
    t.string "subtitle"
    t.string "video"
    t.integer "state_id"
    t.index ["state_id"], name: "index_events_on_state_id"
  end

  create_table "film_production_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filmable_professionals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "filmable_type"
    t.integer "filmable_id"
    t.integer "professional_id"
    t.integer "set_function_id"
    t.text "observation"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_filmable_professionals_on_deleted_at"
    t.index ["filmable_type", "filmable_id"], name: "index_filmable_professionals_on_filmable_type_and_filmable_id"
    t.index ["professional_id"], name: "index_filmable_professionals_on_professional_id"
    t.index ["set_function_id"], name: "index_filmable_professionals_on_set_function_id"
  end

  create_table "filmable_type", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "filmable_type"
    t.integer "filmable_id"
    t.integer "film_production_categories_id"
    t.index ["film_production_categories_id"], name: "index_filmable_type_on_film_production_categories_id"
    t.index ["filmable_type", "filmable_id"], name: "index_filmable_type_on_filmable_type_and_filmable_id"
  end

  create_table "movie_duplicates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "title"
    t.text "available_years"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "original_title"
    t.string "title"
    t.integer "year"
    t.string "length"
    t.text "synopsis"
    t.date "release"
    t.date "brazilian_release"
    t.integer "city_id"
    t.integer "state_id"
    t.integer "age_range_id"
    t.string "cover"
    t.integer "studio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "omdb_directors"
    t.text "omdb_writers"
    t.text "omdb_actors"
    t.text "omdb_genre"
    t.text "omdb_rated"
    t.text "omdb_id"
    t.text "omdb_trailer"
    t.text "trailer"
    t.integer "tmdb_id"
    t.boolean "playing", default: false
    t.integer "user_id"
    t.boolean "lock_updates", default: false
    t.string "countries"
    t.boolean "playing_soon", default: false
    t.boolean "available_netflix", default: false
    t.boolean "available_amazon", default: false
    t.integer "comments_count", default: 0
    t.datetime "deleted_at"
    t.string "imdb_id"
    t.index ["deleted_at"], name: "index_movies_on_deleted_at"
    t.index ["playing"], name: "index_movies_on_playing"
    t.index ["user_id"], name: "index_movies_on_user_id"
  end

  create_table "notifications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "message"
    t.integer "answer", default: 0
    t.integer "status", default: 0
    t.integer "notification_type"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_notifications_on_deleted_at"
  end

  create_table "professionals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "gender"
    t.string "nickname"
    t.date "birthday"
    t.integer "age"
    t.string "cep"
    t.string "address"
    t.string "number"
    t.string "neighbourhood"
    t.string "complement"
    t.string "cpf"
    t.string "phone"
    t.string "mobile"
    t.string "avatar"
    t.text "biography"
    t.integer "city_id"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "set_function_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmdb_id"
    t.date "deathday"
    t.integer "imdb_id"
    t.string "place_of_birth"
    t.boolean "lock_updates", default: false
    t.datetime "deleted_at"
    t.index ["city_id"], name: "index_professionals_on_city_id"
    t.index ["country_id"], name: "index_professionals_on_country_id"
    t.index ["deleted_at"], name: "index_professionals_on_deleted_at"
    t.index ["state_id"], name: "index_professionals_on_state_id"
  end

  create_table "questions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "questionable_type"
    t.integer "questionable_id"
    t.string "title"
    t.text "content"
    t.integer "status", default: 1
    t.integer "origin", default: 2
    t.boolean "spoiler", default: false
    t.boolean "featured", default: false
    t.integer "likes_count", default: 0
    t.integer "dislikes_count", default: 0
    t.integer "comments_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_questions_on_deleted_at"
    t.index ["questionable_type", "questionable_id"], name: "index_questions_on_questionable_type_and_questionable_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "serie_duplicates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "title"
    t.text "available_years"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serie_episodes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "series_id"
    t.string "original_title_ep"
    t.string "title_ep"
    t.integer "year"
    t.string "length"
    t.text "synopsis"
    t.date "release"
    t.date "brazilian_release"
    t.integer "city_id"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "age_range_id"
    t.string "cover"
    t.integer "studio_id"
    t.integer "season"
    t.integer "episode_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_range_id"], name: "index_serie_episodes_on_age_range_id"
    t.index ["city_id"], name: "index_serie_episodes_on_city_id"
    t.index ["country_id"], name: "index_serie_episodes_on_country_id"
    t.index ["series_id"], name: "index_serie_episodes_on_series_id"
    t.index ["state_id"], name: "index_serie_episodes_on_state_id"
    t.index ["studio_id"], name: "index_serie_episodes_on_studio_id"
  end

  create_table "serie_season_episodes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "serie_id"
    t.integer "serie_season_id"
    t.date "air_date"
    t.integer "episode_number"
    t.string "name"
    t.text "overview"
    t.integer "tmdb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serie_id"], name: "index_serie_season_episodes_on_serie_id"
    t.index ["serie_season_id"], name: "index_serie_season_episodes_on_serie_season_id"
  end

  create_table "serie_seasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "serie_id"
    t.string "name"
    t.text "overview"
    t.date "air_date"
    t.integer "tmdb_id"
    t.string "poster"
    t.integer "season_number"
    t.integer "number_of_episodes", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serie_id"], name: "index_serie_seasons_on_serie_id"
  end

  create_table "series", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "original_title"
    t.string "title"
    t.integer "start_year"
    t.integer "finish_year"
    t.string "length"
    t.text "synopsis"
    t.date "release"
    t.date "brazilian_release"
    t.integer "city_id"
    t.integer "state_id"
    t.integer "age_range_id"
    t.string "cover"
    t.integer "studio_id"
    t.integer "number_episodes"
    t.integer "aired_episodes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "omdb_directors"
    t.text "omdb_writers"
    t.text "omdb_actors"
    t.text "omdb_genre"
    t.text "omdb_rated"
    t.text "omdb_id"
    t.text "omdb_trailer"
    t.text "trailer"
    t.integer "tmdb_id"
    t.integer "number_of_seasons", default: 1
    t.boolean "playing", default: false
    t.integer "user_id"
    t.boolean "lock_updates", default: false
    t.string "countries"
    t.boolean "last_released", default: false
    t.boolean "playing_soon", default: false
    t.boolean "available_netflix", default: false
    t.boolean "available_amazon", default: false
    t.integer "comments_count", default: 0
    t.integer "status"
    t.datetime "deleted_at"
    t.string "imdb_id"
    t.index ["deleted_at"], name: "index_series_on_deleted_at"
    t.index ["user_id"], name: "index_series_on_user_id"
  end

  create_table "set_functions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_set_functions_on_user_id"
  end

  create_table "states", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "acronym"
    t.string "name"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "studios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
    t.integer "state_id"
    t.integer "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trending_trailers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "trailer"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filmable_type"
    t.bigint "filmable_id"
    t.index ["filmable_type", "filmable_id"], name: "index_trending_trailers_on_filmable_type_and_filmable_id"
  end

  create_table "trophies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
  end

  create_table "user_filmable_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "filmable_type"
    t.bigint "filmable_id"
    t.integer "rating"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_user_filmable_ratings_on_deleted_at"
    t.index ["filmable_type", "filmable_id"], name: "index_user_filmable_ratings_on_filmable_type_and_filmable_id"
    t.index ["user_id"], name: "index_user_filmable_ratings_on_user_id"
  end

  create_table "user_filmables", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "filmable_type"
    t.integer "filmable_id"
    t.integer "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "media"
    t.integer "version"
    t.integer "position"
    t.string "store"
    t.boolean "gift"
    t.float "price"
    t.date "bought"
    t.string "isbn"
    t.string "borrowed"
    t.string "observation"
    t.string "cover"
    t.boolean "box", default: false
    t.string "box_title"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_filmables_on_deleted_at"
    t.index ["filmable_type", "filmable_id"], name: "index_user_filmables_on_filmable_type_and_filmable_id"
    t.index ["user_id"], name: "index_user_filmables_on_user_id"
  end

  create_table "user_trophies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "trophy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_trophies_on_deleted_at"
    t.index ["trophy_id"], name: "index_user_trophies_on_trophy_id"
    t.index ["user_id"], name: "index_user_trophies_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.integer "gender"
    t.string "nickname"
    t.date "birthday"
    t.integer "age"
    t.string "cep"
    t.string "address"
    t.string "number"
    t.string "neighbourhood"
    t.string "complement"
    t.integer "role"
    t.string "cpf"
    t.string "phone"
    t.string "mobile"
    t.string "avatar"
    t.text "biography"
    t.boolean "terms_of_use", default: false
    t.boolean "accepted_term_of_use"
    t.date "registered_at"
    t.integer "city_id"
    t.integer "state_id"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collection_privacy", default: 0
    t.datetime "deleted_at"
    t.integer "crop_x"
    t.integer "crop_y"
    t.integer "crop_w"
    t.integer "crop_h"
    t.string "provider"
    t.string "uid"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["state_id"], name: "index_users_on_state_id"
  end

  create_table "visits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "controller"
    t.string "action"
    t.string "path"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  create_table "votes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  add_foreign_key "set_functions", "users"
end

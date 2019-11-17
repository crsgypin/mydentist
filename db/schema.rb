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

ActiveRecord::Schema.define(version: 20191116144300) do

  create_table "booking_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "doctor_id"
    t.integer "patient_id"
    t.integer "service_id"
    t.integer "line_account_id"
    t.integer "event_id"
    t.date "date"
    t.integer "hour", limit: 1
    t.integer "minute", limit: 1
    t.integer "duration", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_booking_events_on_clinic_id"
    t.index ["doctor_id"], name: "index_booking_events_on_doctor_id"
    t.index ["event_id"], name: "index_booking_events_on_event_id"
    t.index ["line_account_id"], name: "index_booking_events_on_line_account_id"
    t.index ["patient_id"], name: "index_booking_events_on_patient_id"
    t.index ["service_id"], name: "index_booking_events_on_service_id"
  end

  create_table "clinic_durations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.string "wday_hour_minute", limit: 50
    t.integer "wday", limit: 1
    t.integer "hour", limit: 1
    t.integer "minute", limit: 1
    t.integer "duration", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_clinic_durations_on_clinic_id"
    t.index ["wday_hour_minute"], name: "index_clinic_durations_on_wday_hour_minute"
  end

  create_table "clinic_line_broadcasts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinic_line_keywords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinic_line_knowledge_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_clinic_line_knowledge_categories_on_clinic_id"
  end

  create_table "clinic_line_knowledges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "knowledge_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["knowledge_category_id"], name: "index_clinic_line_knowledges_on_knowledge_category_id"
  end

  create_table "clinic_line_systems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "category", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinic_patient_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "patient_id"
    t.integer "category", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_clinic_patient_notifications_on_clinic_id"
    t.index ["patient_id"], name: "index_clinic_patient_notifications_on_patient_id"
  end

  create_table "clinic_vacation_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "vacation_id"
    t.integer "event_id"
    t.integer "line_sending_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_clinic_vacation_notifications_on_event_id"
    t.index ["line_sending_id"], name: "index_clinic_vacation_notifications_on_line_sending_id"
    t.index ["vacation_id"], name: "index_clinic_vacation_notifications_on_vacation_id"
  end

  create_table "clinic_vacations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_clinic_vacations_on_clinic_id"
  end

  create_table "clinics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "friendly_id"
    t.string "name", limit: 100
    t.string "name_en", limit: 100
    t.string "phone", limit: 100
    t.string "phone2", limit: 100
    t.string "address", limit: 100
    t.text "description"
    t.string "channel_secret"
    t.string "channel_token"
    t.text "recommend"
    t.text "photo"
    t.string "clinic_durations_note", limit: 500, default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctor_durations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "doctor_id"
    t.string "wday_hour_minute", limit: 50
    t.integer "wday", limit: 1
    t.integer "hour", limit: 1
    t.integer "minute", limit: 1
    t.integer "duration", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_doctor_durations_on_doctor_id"
    t.index ["wday_hour_minute"], name: "index_doctor_durations_on_wday_hour_minute"
  end

  create_table "doctor_services", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "doctor_id"
    t.integer "service_id"
    t.integer "duration", default: 15
    t.integer "has_line_booking", limit: 1, default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_doctor_services_on_doctor_id"
    t.index ["service_id"], name: "index_doctor_services_on_service_id"
  end

  create_table "doctor_vacation_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "vacation_id"
    t.integer "event_id"
    t.integer "line_sending_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_doctor_vacation_notifications_on_event_id"
    t.index ["line_sending_id"], name: "index_doctor_vacation_notifications_on_line_sending_id"
    t.index ["vacation_id"], name: "index_doctor_vacation_notifications_on_vacation_id"
  end

  create_table "doctor_vacations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "doctor_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_doctor_vacations_on_doctor_id"
  end

  create_table "doctors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "friendly_id"
    t.integer "clinic_id"
    t.integer "status", limit: 1, default: 1
    t.string "name", limit: 100
    t.string "title"
    t.text "experience"
    t.string "pro"
    t.text "intro"
    t.string "photo"
    t.integer "gender", limit: 1
    t.string "phone", limit: 50
    t.string "note", limit: 500
    t.string "web_link"
    t.string "doctor_durations_note", limit: 500, default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_doctors_on_clinic_id"
  end

  create_table "event_durations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "event_id"
    t.string "wday_hour_minute", limit: 50
    t.integer "wday", limit: 1
    t.integer "hour", limit: 1
    t.integer "minute", limit: 1
    t.integer "duration", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_durations_on_event_id"
    t.index ["wday_hour_minute"], name: "index_event_durations_on_wday_hour_minute"
  end

  create_table "event_notification_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "category", limit: 1
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_event_notification_templates_on_clinic_id"
  end

  create_table "event_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "event_id"
    t.integer "new_event_id"
    t.integer "booking_event_id"
    t.integer "line_account_id"
    t.integer "line_sending_id"
    t.integer "notification_template_id"
    t.integer "status", limit: 1, default: 0
    t.string "args"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_event_id"], name: "index_event_notifications_on_booking_event_id"
    t.index ["event_id"], name: "index_event_notifications_on_event_id"
    t.index ["line_account_id"], name: "index_event_notifications_on_line_account_id"
    t.index ["line_sending_id"], name: "index_event_notifications_on_line_sending_id"
    t.index ["new_event_id"], name: "index_event_notifications_on_new_event_id"
    t.index ["notification_template_id"], name: "index_event_notifications_on_notification_template_id"
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "doctor_id"
    t.integer "patient_id"
    t.integer "service_id"
    t.integer "line_account_id"
    t.integer "ori_event_id"
    t.integer "status", limit: 1
    t.integer "source", limit: 1, default: 1
    t.integer "health_insurance_status", limit: 1
    t.date "date"
    t.integer "hour", limit: 1
    t.integer "minute", limit: 1
    t.integer "duration", limit: 1
    t.integer "event_durations_count", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_events_on_clinic_id"
    t.index ["doctor_id"], name: "index_events_on_doctor_id"
    t.index ["line_account_id"], name: "index_events_on_line_account_id"
    t.index ["ori_event_id"], name: "index_events_on_ori_event_id"
    t.index ["patient_id"], name: "index_events_on_patient_id"
    t.index ["service_id"], name: "index_events_on_service_id"
  end

  create_table "line_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "patient_id"
    t.string "line_user_id"
    t.integer "status"
    t.integer "dialog_status", limit: 1
    t.integer "dialog_status_step", limit: 1
    t.string "display_name"
    t.string "picture_url"
    t.text "status_message"
    t.string "reply_token"
    t.datetime "reply_token_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_line_accounts_on_patient_id"
  end

  create_table "line_keywords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "template_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_line_keywords_on_template_id"
  end

  create_table "line_sending_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "sending_id"
    t.integer "message_type", limit: 1
    t.integer "template_type", limit: 1
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sending_id"], name: "index_line_sending_messages_on_sending_id"
  end

  create_table "line_sendings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.integer "client_sending_id"
    t.integer "source", limit: 1
    t.integer "server_type", limit: 1
    t.integer "status", limit: 1
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_line_sendings_on_account_id"
    t.index ["client_sending_id"], name: "index_line_sendings_on_client_sending_id"
  end

  create_table "line_template_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "template_id"
    t.integer "category"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_line_template_messages_on_template_id"
  end

  create_table "line_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "templateable_type"
    t.integer "templateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["templateable_type", "templateable_id"], name: "index_templateable_id"
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.string "account"
    t.string "username"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "role", limit: 1
    t.integer "level"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_members_on_clinic_id"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "patients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "friendly_id"
    t.integer "clinic_id"
    t.integer "default_doctor_id"
    t.integer "current_event_id"
    t.integer "last_tooth_cleaning_event_id"
    t.integer "profile_status", limit: 1, default: 0
    t.integer "source", limit: 1, default: 1
    t.string "name", limit: 100
    t.string "phone", limit: 100
    t.string "phone2"
    t.string "person_id", limit: 100
    t.date "birthday"
    t.integer "gender", limit: 1
    t.integer "health_insurance_status"
    t.string "skill"
    t.string "photo"
    t.string "address"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_patients_on_clinic_id"
    t.index ["current_event_id"], name: "index_patients_on_current_event_id"
    t.index ["default_doctor_id"], name: "index_patients_on_default_doctor_id"
    t.index ["last_tooth_cleaning_event_id"], name: "index_patients_on_last_tooth_cleaning_event_id"
  end

  create_table "services", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "clinic_id"
    t.integer "category", default: 0
    t.string "name", limit: 100
    t.integer "duration", default: 15
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_services_on_clinic_id"
  end

end

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 10) do

  create_table "admins", :force => true do |t|
    t.string   "login_id"
    t.string   "name"
    t.boolean  "enabled"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_questions", :force => true do |t|
    t.integer  "exam_id",     :null => false
    t.integer  "question_id", :null => false
    t.integer  "position",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exam_questions", ["exam_id"], :name => "index_exam_questions_on_exam_id"
  add_index "exam_questions", ["question_id"], :name => "index_exam_questions_on_question_id"

  create_table "exams", :force => true do |t|
    t.string   "name"
    t.integer  "created_by"
    t.boolean  "results_viewable"
    t.integer  "status"
    t.boolean  "skippable"
    t.string   "exam_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.boolean  "depreciated"
    t.binary   "q_data",        :default => "", :null => false
    t.integer  "master_id"
    t.string   "question_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "question_id",                      :null => false
    t.integer  "student_exam_id",                  :null => false
    t.string   "answer"
    t.boolean  "marked"
    t.string   "mark"
    t.string   "score",           :default => "0"
    t.boolean  "skipped"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["question_id"], :name => "index_results_on_question_id"
  add_index "results", ["student_exam_id"], :name => "index_results_on_student_exam_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "student_exams", :force => true do |t|
    t.integer  "student_id",        :null => false
    t.integer  "exam_id",           :null => false
    t.boolean  "radio_button_exam"
    t.integer  "attempt_position"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "login_id"
    t.string   "name"
    t.boolean  "enabled"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "attempt_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["login_id"], :name => "index_students_on_login_id", :unique => true

  create_table "teachers", :force => true do |t|
    t.string   "login_id"
    t.string   "name"
    t.boolean  "enabled"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teachers", ["login_id"], :name => "index_teachers_on_login_id", :unique => true

end

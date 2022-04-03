class CreateStudentExams < ActiveRecord::Migration
  def self.up
    create_table :student_exams do |t|
      t.references :student, :null => false
      t.references :exam, :null => false
      t.boolean :radio_button_exam
      t.integer :attempt_position
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :student_exams
  end
end

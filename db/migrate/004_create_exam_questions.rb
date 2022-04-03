class CreateExamQuestions < ActiveRecord::Migration
  def self.up
    create_table :exam_questions do |t|
      t.references :exam, :null => false
      t.references :question, :null => false
      t.integer :position, :null => false

      t.timestamps
    end
    add_index :exam_questions, :exam_id
    add_index :exam_questions, :question_id
  end

  def self.down
    drop_table :exam_questions
  end
end

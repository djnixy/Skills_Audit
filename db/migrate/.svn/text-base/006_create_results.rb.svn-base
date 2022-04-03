class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.references :question, :null => false
      t.references :student_exam, :null => false
      t.string :answer
      t.boolean :marked
      t.string :mark
      t.string :score, :default => 0
      t.boolean :skipped

      t.timestamps
    end
    add_index :results, :question_id
    add_index :results, :student_exam_id
  end

  def self.down
    drop_table :results
  end
end

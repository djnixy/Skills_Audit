class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.string :name
      t.integer :created_by
      t.boolean :results_viewable
      t.integer :status
      t.boolean :skippable
      t.string :exam_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :exams
  end
end

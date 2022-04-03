class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.boolean :depreciated
      t.column :q_data, :binary, :null => false, :size => 400000
      #t.column :q_img, :binary, :size => 50000000
      t.integer :master_id
      t.string :question_type
      
      t.timestamps
    end
    
    
  end

  def self.down
    drop_table :questions
  end
end

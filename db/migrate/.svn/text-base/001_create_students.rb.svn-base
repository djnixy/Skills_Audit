class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :login_id
      t.string :name
      t.boolean :enabled
      t.string :hashed_password
      t.string :salt
      t.integer :attempt_position
      
      t.timestamps
    end
    
    add_index(:students, :login_id, :unique => :true)
  end

  def self.down
    drop_table :students
  end
end

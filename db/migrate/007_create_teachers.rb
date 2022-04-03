class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.string :login_id
      t.string :name
      t.boolean :enabled
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end
    
    add_index(:teachers, :login_id, :unique => :true)
  end

  def self.down
    drop_table :teachers
  end
end

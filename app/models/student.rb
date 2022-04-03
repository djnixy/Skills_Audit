require 'digest/sha1'
class Student < ActiveRecord::Base
  
  #Student's login_id must be exist
  validates_presence_of   :login_id 
  
  #Student's name must be unique 
  validates_uniqueness_of :login_id 
  
  #Student's name must be exist
  validates_presence_of   :name 
  
  #Password and password confirmation must match
  attr_accessor   :password_confirmation
  validates_confirmation_of :password 
  
  validate :password_non_blank 

  has_many :student_exams
  
  #Find the exam for student, find the exam that in progress, if there is none, then start a new exam
  def find_exam
    s = student_exams.find(:first, :conditions => { :status => 2 })
    if s == nil
      s = student_exams.find(:first, :conditions => { :status => 1 })
    end
    return s
  end
  
  #Find completed exams
  def find_completed_exams
    s = student_exams.find(:all, :conditions => { :status => 3 })
    return s
  end
  
  #Find last completed exam, for last_results
  def find_last_completed_exam
    #student_exams.find(:first, :order => 'updated_at desc', :conditions => {:status => 3}).results.find(:all) --> use this if the exam MUST be finished first
    student_exams.find(:first, :order => 'updated_at desc').results.find(:all) # the exam doesn't have to be finished to view the last result
  end
  
  
  def get_exam_list
    y = ""
    student_exams.find(:all).each { |x| y += "<br />" + x.get_exam_information }
    #y[0] = "" unless y[0] == nil
    return y
  end
  
  #Assign exam to student, set the exam status to 1 (First run)  
  def assign_exam(exam_id)
    logger.info("assign_exam: " + exam_id.to_s + ", student_id: " + id.to_s)
    st_exam = StudentExam.new
    st_exam.exam_id = exam_id
    st_exam.student_id = id
    st_exam.status = 1
    st_exam.save
  end
  
  #
  def assign(s)
    logger.info("assign: " + s.to_ss)
    if s == 0
      return
    elsif s == 1
      assign_exam(1)
    end
  end
  
    #Match the login_id and password entered with database
  def self.authenticate(name, password)
    user = self.find_by_login_id(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Student.encrypted_password(self.password, self.salt)
  end
  
  def get_full_name
    return first_name.to_s + last_name.to_s
  end
  
  def display_details
    s = "student id: " + id.to_s + ", enabled: " + enabled.to_s
    return s
  end
  
private
  #Check if the hashed password is blank
  def password_non_blank
    errors.add_to_base("Missing Password") if hashed_password.blank?
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end

require 'digest/sha1'
class Admin < ActiveRecord::Base
  
  #Validate the presence of login_id
  validates_presence_of   :login_id
  
  #Validate the uniqueness of login_id
  validates_uniqueness_of :login_id
  
  #Password confirmation must match with the password
  attr_accessor   :password_confirmation
  validates_confirmation_of :password
  

  validate :password_non_blank
  
  #Match the login_id and password entered with database
  def self.authenticate(login_id, password)
    user = self.find_by_login_id(login_id)
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
    self.hashed_password = Admin.encrypted_password(self.password, self.salt)
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
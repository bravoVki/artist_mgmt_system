class User < ApplicationRecord
    has_secure_password
  
    enum gender: { m: 0, f: 1, o: 2 }
  
    # validates :email, presence: true, uniqueness: true
    # validates :first_name, 
    # validates :last_name, 
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true, length: { minimum: 6 }
    validates :phone, uniqueness: true, length: { minimum: 6 }
    # validates :dob, 
    # validates :gender, 
    # validates :address, 
  end
  
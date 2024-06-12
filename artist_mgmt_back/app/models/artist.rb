class Artist < ApplicationRecord
    has_many :songs, dependent: :destroy
  
    enum gender: { m: 0, f: 1, o: 2 }
  
    validates :name, presence: true
end
  
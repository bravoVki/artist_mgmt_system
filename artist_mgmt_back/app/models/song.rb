class Song < ApplicationRecord
  belongs_to :artist

  enum genere: { rock: 0, jazz: 1, classic: 2, rnb: 3, country: 4 }

  validates :title, presence: true
end

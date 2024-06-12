# class CreateSongs < ActiveRecord::Migration[7.1]
#   def change
#     create_table :songs do |t|
#       t.references :artist, null: false, foreign_key: true
#       t.string :title
#       t.string :album_name
#       t.integer :genere

#       t.timestamps
#     end
#   end
# end

class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :title
      t.string :album_name
      t.integer :genere # Change 'genere' to 'genre'

      t.timestamps
    end
  end
end

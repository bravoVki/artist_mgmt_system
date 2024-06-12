class SongsController < ApplicationController
  include ActionController::MimeResponds
  before_action :authorize_request
  before_action :set_artist, except: %i[index_all]
  before_action :set_song, only: %i[show update destroy]
  require 'csv'
  # GET /artists/:artist_id/songs
  def index
    @songs = @artist.songs.page(params[:page]).per(5)
    render json:{
      status: "Success",
      message: "Loaded all songs",
      data:@songs,
      # data: song_serializer(@songs),
      meta: pagination_meta(@songs)
    }
  end

  # GET /songs
  def index_all
    @songs = Song.all
    render json: { status: "Success", message: "Loaded all songs", data: @songs }
  end

  # GET /artists/:artist_id/songs/:id
  def show
    render json: { status: "Success", message: "Loaded song", data: @song }
  end

  # POST /artists/:artist_id/songs
  def create
    @song = @artist.songs.new(song_params)

    if @song.save
      render json: { status: "Success", message: "Song created", data: song_serializer(@song) }, status: :created, location: artist_song_url(@artist, @song)
    else
      render json: { status: "Error", message: "Song creation failed", errors: @song.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artists/:artist_id/songs/:id
  def update
    if @song.update(song_params)
      render json: { status: "Success", message: "Song updated", data:song_serializer(@song) }
    else
      render json: { status: "Error", message: "Song update failed", errors: @song.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /artists/:artist_id/songs/:id
  def destroy
    @song.destroy
    render json: { status: "Success", message: "Song deleted", data: @song }
  end


  # GET /artists/:artist_id/songs/export for CSV
  
  def export
    @songs = @artist.songs

    respond_to do |format|
      format.csv { send_data generate_csv(@songs), filename: "songs-#{Date.today}.csv" }
      format.any { render status: :not_acceptable }  # Catch-all for unsupported formats
    end
  end

  # POST /artists/:artist_id/songs/upload
def upload
  begin
    uploaded_file = params[:file]
    if uploaded_file.nil?
      Rails.logger.error "No file uploaded"
      render json: { status: 'Error', message: "No file uploaded" }, status: :unprocessable_entity
      return
    end

    Rails.logger.info "Uploaded file: #{uploaded_file.original_filename}"

    csv_data = CSV.read(uploaded_file.path, headers: true)
    Rails.logger.info "CSV Data: #{csv_data.inspect}"

    # Genre mapping hash for genere
    genre_mapping = {
      'rock' => 0,
      'jazz' => 1,
      'classic' => 2,
      'rnb' => 3,
      'country' => 4
    }

    created_songs = []
    csv_data.each do |row|
      Rails.logger.info "Processing row: #{row.inspect}"
      
      # Map genre name to enum value
      genre_value = genre_mapping[row['Genere'].downcase]

      song = @artist.songs.create(
        title: row['Title'],
        album_name: row['Album Name'],
        genere: genre_value
      )
      if song.persisted?
        Rails.logger.info "Created song: #{song.inspect}"
        created_songs << song
      else
        Rails.logger.error "Failed to create song: #{song.errors.full_messages}"
      end
    end

    if created_songs.any?
      render json: { status: 'Success', message: 'Songs created from CSV', songs: created_songs }
    else
      render json: { status: 'Error', message: 'No songs were created from the CSV' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Error: #{e.message}"
    render json: { status: 'Error', message: "Failed to upload CSV: #{e.message}" }, status: :unprocessable_entity
  end
end


  private
  def song_serializer(song)
    return{
    song_name:song.title,
    album_name:song.album_name,
    genere:song.genere
    }
    
  end


  def set_artist
    @artist = Artist.find(params[:artist_id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: "Error", message: "Artist not found" }, status: :not_found
  end

  def set_song
    @song = @artist.songs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: "Error", message: "Song not found" }, status: :not_found
  end

  def song_params
    params.require(:song).permit(:title, :album_name, :genere)
  end

  def pagination_meta(object)
    {
      total_pages: object.total_pages,
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_count: object.total_count
    }
  end


  def generate_csv(songs)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Title", "Album Name", "Genere", "Created At", "Updated At"]

      songs.each do |song|
        csv << [song.id, song.title, song.album_name, song.genere, song.created_at, song.updated_at]
      end
    end
  end
end

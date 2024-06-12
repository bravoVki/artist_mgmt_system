


class SongsController < ApplicationController
    # before_action :authenticate_user!
    before_action :authorize_request
    before_action :set_artist, except: %i[ index_all]
    before_action :set_song, only: %i[show update destroy]
  
    # GET /artists/:artist_id/songs
    def index
      @songs = @artist.songs
      render json: { status: "Success", message: "Loaded all songs", data: @songs }
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
        render json: { status: "Success", message: "Song created", data: @song }, status: :created, location: artist_song_url(@artist, @song)
      else
        render json: { status: "Error", message: "Song creation failed", errors: @song.errors }, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /artists/:artist_id/songs/:id
    def update
      if @song.update(song_params)
        render json: { status: "Success", message: "Song updated", data: @song }
      else
        render json: { status: "Error", message: "Song update failed", errors: @song.errors }, status: :unprocessable_entity
      end
    end
  
    # DELETE /artists/:artist_id/songs/:id
    def destroy
      @song.destroy
      render json: { status: "Success", message: "Song deleted", data: @song }
    end
  
    private
  
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
  end
  
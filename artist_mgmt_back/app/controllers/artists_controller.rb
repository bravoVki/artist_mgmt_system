class ArtistsController < ApplicationController
  before_action :authorize_request
  before_action :set_artist, only: %i[ show update destroy ]

  # GET /artists
  # pagination bata ek page ma 5 ota data 
  def index
    @artists = Artist.page(params[:page]).per(5)
    render json:{
      status:"success",
      message:"Loaded all artists",
      data: @artists,
      meta: pagination_meta(@artists)
    }
   
  end

  # GET /artists/1
  def show
    render json: @artist
  end

  # POST /artists
  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      render json: @artist, status: :created, location: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artists/1
  def update
    if @artist.update(artist_params)
      render json: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /artists/1
  def destroy
    @artist.destroy
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
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
end

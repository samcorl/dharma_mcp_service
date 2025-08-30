class FeaturedArtistPagesController < ApplicationController
  before_action :set_featured_artist_page, only: %i[ show update destroy ]

  # GET /featured_artist_pages
  def index
    @featured_artist_pages = FeaturedArtistPage.all

    render json: @featured_artist_pages
  end

  # GET /featured_artist_pages/1
  def show
    render json: @featured_artist_page
  end

  # POST /featured_artist_pages
  def create
    @featured_artist_page = FeaturedArtistPage.new(featured_artist_page_params)

    if @featured_artist_page.save
      render json: @featured_artist_page, status: :created, location: @featured_artist_page
    else
      render json: @featured_artist_page.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /featured_artist_pages/1
  def update
    if @featured_artist_page.update(featured_artist_page_params)
      render json: @featured_artist_page
    else
      render json: @featured_artist_page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /featured_artist_pages/1
  def destroy
    @featured_artist_page.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_artist_page
      @featured_artist_page = FeaturedArtistPage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def featured_artist_page_params
      params.require(:featured_artist_page).permit(:artist_name, :bio, :featured_image, :portfolio_images, :social_links, :featured_until, :active)
    end
end

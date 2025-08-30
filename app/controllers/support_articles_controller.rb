class SupportArticlesController < ApplicationController
  before_action :set_support_article, only: %i[ show update destroy ]

  # GET /support_articles
  def index
    @support_articles = SupportArticle.all

    render json: @support_articles
  end

  # GET /support_articles/1
  def show
    render json: @support_article
  end

  # POST /support_articles
  def create
    @support_article = SupportArticle.new(support_article_params)

    if @support_article.save
      render json: @support_article, status: :created, location: @support_article
    else
      render json: @support_article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /support_articles/1
  def update
    if @support_article.update(support_article_params)
      render json: @support_article
    else
      render json: @support_article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /support_articles/1
  def destroy
    @support_article.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_support_article
      @support_article = SupportArticle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def support_article_params
      params.require(:support_article).permit(:title, :content, :category, :tags, :helpful_count, :view_count, :published)
    end
end

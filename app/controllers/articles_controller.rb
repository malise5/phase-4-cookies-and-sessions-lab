class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end


  # When a user makes a GET request to /articles/:id, the following should happen:
  def show
    session[:page_views] ||= 0
    # For every request to /articles/:id, increment the value of session[:page_views] by 1
    session[:page_views] += 1
    # If the user has viewed fewer than 3 pages, render a JSON response with the article data.
    if session[:page_views] < 3
    article = Article.find(params[:id])
    render json: article
    # If the user has viewed 3 or more pages, render a JSON response including an error message, and a status code of 401 unauthorized
    else
      render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

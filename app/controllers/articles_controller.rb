class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def search
    @articles = if params[:query].present?
                  Article.where("title LIKE ? OR content LIKE ?",
                                "%#{params[:query]}%",
                                "%#{params[:query]}%")
                else
                  Article.none
                end

    render partial: "results"
  end
end

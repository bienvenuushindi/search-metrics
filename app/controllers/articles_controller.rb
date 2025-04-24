class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def search
    @articles = if params_exist?
      Article.where("title LIKE ? OR content LIKE ?",
                    "%#{params[:term]}%",
                    "%#{params[:term]}%")
    else
      Article.none
    end

    if turbo_frame_request?
      if params[:commit].present?
        # create(search_params)
      else
        render partial: "results", locals: { articles: @articles, term: search_params }
      end
    else
      render "index", locals: { articles: @articles, term: "" }
    end
  end

  private

  def params_exist?
    params[:term].present?
  end
  def search_params
    params[:term].strip
  end
end

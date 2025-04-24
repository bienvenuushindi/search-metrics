class ArticlesController < ApplicationController
  def search
    @pagy_queries, @queries = pagy(SearchQuery.all.order(count: :desc, created_at: :desc), items: 6)
    @logs = SearchLog.none
    @users = SearchLog.distinct.pluck(:ip_address).sort
    @pagy = nil
    @articles = Article.none
    if params_exist?
      articles_query = Article.search(search_params)
      results_count = articles_query.count
      @pagy, @articles = pagy(articles_query, items: 6)
      SearchService.push_to_redis(REDIS, { creator: request.remote_ip, value: search_params, results_count: results_count })
    end
    if turbo_frame_request?
        render partial: "results", locals: { articles: @articles,  term: search_params }
    else
      render "index", locals: { articles: @articles, term: "" }
    end
  end

  def query_logs
     @search_query = SearchQuery.find(params[:id])
     # @logs = @search_query.search_logs
     @logs = @search_query.search_logs.group_by(&:ip_address)
    respond_to do |format|
      format.turbo_stream
    end
  end
  def user_logs
    @selected_ip =  params[:ip]
    @user_logs = SearchLog
                    .includes(:search_query)
                    .where(ip_address: params[:ip])
                    .group_by(&:search_query_id)
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def params_exist?
    params[:term].present?
  end
  def search_params
    params_exist? ? params[:term].strip : ""
  end
end

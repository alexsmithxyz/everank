class TitlesController < ApplicationController
  # GET /
  def index
    params[:page] ||= 1

    @paginator, @titles = Title.paginate(per_page: 20, current_page: params[:page])
  end

  # GET /titles/1
  def show
    @title = Title.find(params.expect(:id))
  end
end

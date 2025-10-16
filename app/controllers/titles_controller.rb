class TitlesController < ApplicationController
  # GET /
  def index
    authorize Title

    params[:page] ||= 1

    @paginator, @titles = Title.paginate(per_page: 20, current_page: params[:page])
  end

  # GET /titles/1
  def show
    @title = authorize Title.find(params.expect(:id))
  end
end

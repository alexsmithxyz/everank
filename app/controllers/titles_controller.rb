class TitlesController < ApplicationController
  # GET /
  def index
    @titles = Title.all
  end

  # GET /titles/1
  def show
    @title = Title.find(params.expect(:id))
  end
end

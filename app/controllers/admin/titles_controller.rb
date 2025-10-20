class Admin::TitlesController < ApplicationController
  before_action :set_title, only: %i[edit update destroy]

  # GET /admin/titles/new
  def new
    @title = authorize Title.new
  end

  # GET /admin/titles/1/edit
  def edit; end

  # POST /admin/titles
  def create
    @title = authorize Title.new(title_params)

    respond_to do |format|
      if @title.save
        format.html { redirect_to @title, notice: "Title was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/titles/1
  def update
    respond_to do |format|
      if @title.update(title_params)
        format.html { redirect_to @title, notice: "Title was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/titles/1
  def destroy
    @title.destroy!

    respond_to do |format|
      format.html { redirect_to titles_path, notice: "Title was successfully destroyed.", status: :see_other }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_title
    @title = authorize Title.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def title_params
    params.expect(title: %i[name date_available description])
  end
end

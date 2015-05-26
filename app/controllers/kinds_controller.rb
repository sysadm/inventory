class KindsController < ApplicationController
  before_action :set_kind, only: [:show, :edit, :update, :destroy, :switch]
  before_filter :check_authorization, except: [:show, :index]

  # GET /kinds
  # GET /kinds.json
  def index
    params['archive'] == "true" ? @archive = true : @archive = false
    @kinds = Kind.where(archive: @archive)
  end

  # GET /kinds/1
  # GET /kinds/1.json
  def show
  end

  # GET /kinds/new
  def new
    @kind = Kind.new
  end

  # GET /kinds/1/edit
  def edit
  end

  # POST /kinds
  # POST /kinds.json
  def create
    @kind = Kind.new(kind_params)

    respond_to do |format|
      if @kind.save
        format.html { redirect_to @kind, notice: "#{t(:kind)} #{t(:was_successfully_created)}." }
        format.json { render :show, status: :created, location: @kind }
      else
        format.html { render :new }
        format.json { render json: @kind.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kinds/1
  # PATCH/PUT /kinds/1.json
  def update
    respond_to do |format|
      if @kind.update(kind_params)
        format.html { redirect_to @kind, notice: "#{t(:kind)} #{t(:was_successfully_updated)}." }
        format.json { render :show, status: :ok, location: @kind }
      else
        format.html { render :edit }
        format.json { render json: @kind.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kinds/1
  # DELETE /kinds/1.json
  def destroy
    @kind.destroy
    respond_to do |format|
      format.html { redirect_to kinds_url, notice: "#{t(:kind)} #{t(:was_successfully_destroyed)}." }
      format.json { head :no_content }
    end
  end

  def switch
    status = !@kind.archive
    if status
      notice = "#{t(:kind)} #{t(:was_successfully_archived)}."
    else
      notice = "#{t(:kind)} #{t(:was_successfully_restored)}."
    end
    @kind.update_attribute(:archive, status)
    redirect_to kinds_path, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kind
      @kind = Kind.find(params[:id])
    end

    def check_authorization
      if current_user.is_admin?
        true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to kinds_path
      end
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def kind_params
      params.require(:kind).permit(:description, :old_id)
    end
end

class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy, :switch]
  before_filter :check_authorization, except: [:show, :index]

  # GET /departments
  # GET /departments.json
  def index
    params['archive'] == "true" ? @archive = true : @archive = false
    @departments = Department.where(archive: @archive)
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: "#{t(:department)} #{t(:was_successfully_created)}." }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: "#{t(:department)} #{t(:was_successfully_updated)}." }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: "#{t(:department)} #{t(:was_successfully_destroyed)}." }
      format.json { head :no_content }
    end
  end

  def switch
    status = !@department.archive
    if status
      notice = "#{t(:department)} #{t(:was_successfully_archived)}."
    else
      notice = "#{t(:department)} #{t(:was_successfully_restored)}."
    end
    @department.update_attribute(:archive, status)
    redirect_to departments_path, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    def check_authorization
      if current_user.is_admin?
        true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to departments_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:title, :old_id)
    end
end

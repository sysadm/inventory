class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :switch]
  before_action :set_departments, only: [:new, :edit, :update]
  before_filter :check_authorization, except: [:show, :index]

  # GET /users
  def index
    params['archive'] == "true" ? @archive = true : @archive = false
    @users = User.where(archive: @archive)
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "#{t(:user)} #{t(:was_successfully_created)}."
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "#{t(:user)} #{t(:was_successfully_updated)}."
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: "#{t(:user)} #{t(:was_successfully_destroyed)}."
  end

  def import_new_users_from_ldap
    User.delay.ldap_import
    redirect_to users_path, notice: t(:ldap_users_will_be_updated)
  end

  def switch
    status = !@user.archive
    if status
      notice = "#{t(:user)} #{t(:was_successfully_archived)}."
    else
      notice = "#{t(:user)} #{t(:was_successfully_restored)}."
    end
    @user.update_attribute(:archive, status)
    redirect_to users_path, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :name, :first_name, :last_name, :email, :department_id, :login, :read_only, :admin, :old_id)
    end

    def check_authorization
      if current_user.is_admin?
        true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to users_path
      end
    end

    def set_departments
      @departments = Department.all.inject([]){|res, d| res << [d.title,d.id]}
    end
end

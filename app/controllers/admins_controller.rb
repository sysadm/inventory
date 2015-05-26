class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_filter :check_authorization, except: [:show, :index]

  def index
    @admins = Admin.all
  end

  def show
  end

  def new
    @admin = Admin.new
  end

  def edit
  end

  def create
    @admin = Admin.new(admin_params)
    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: "#{t(:administrator)} #{t(:was_successfully_created)}." }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: "#{t(:administrator)} #{t(:was_successfully_updated)}." }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: "#{t(:administrator)} #{t(:was_successfully_destroyed)}." }
    end
  end

  private

    def set_admin
      @admin = Admin.find(params[:id])
    end

    def check_authorization
      if current_user.is_admin?
        true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to admins_path
      end
    end

    def admin_params
      params.require(:admin).permit(:email, :password, :password_confirmation)
    end
end

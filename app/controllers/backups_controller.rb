class BackupsController < ApplicationController
  before_action :set_backup, only: [:show, :destroy, :download, :rollback]
  before_filter :check_authorization, except: [:download, :show, :index]

  # GET /backups
  # GET /backups.json
  def index
    @backups = Backup.order(:id)
  end

  # GET /backups/1
  # GET /backups/1.json
  def show
  end

  def initial
    Backup.generate_without_delay if Backup.count == 0
    if Backup.count > 0
      flash[:notice] = "#{t(:backup)} #{t(:was_successfully_created)}."
    else
      flash[:error] = t(:something_went_wrong)
    end
    redirect_to backups_url
  end

  def download
    csv = File.open(Backup.path(@backup.file), 'rb').read
    send_data csv, :filename => @backup.file
  end

  def rollback
    Backup.delay.rollback_to(@backup)
    redirect_to backups_url, notice: t(:backup_will_be_reverted)
  end

  # DELETE /backups/1
  def destroy
    if @backup.current
      redirect_to backups_url, error: t(:cannot_delete_current_scheme)
    else
      @backup.destroy
      redirect_to backups_url, notice: "#{t(:backup)} #{t(:was_successfully_destroyed)}."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_backup
      @backup = Backup.find(params[:id])
    end

    def check_authorization
      if current_user.is_admin?
        true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to backups_path
      end
    end
end

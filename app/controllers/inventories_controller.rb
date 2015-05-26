class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy, :switch]
  before_action :set_kinds_vendors_and_users, only: [:new, :edit, :update]
  before_filter :set_layout
  before_filter :check_authorization, except: [:show, :index, :search, :reset]
  after_action :make_backup, only: [:update, :create, :destroy, :switch]

  # GET /inventory
  # GET /inventory.json
  def index
    @min_search_value = 3
    if @current_user.is_admin? or @read_only
      @inventories = Inventory.where(archive: false).order(tag: :desc).page params[:page]
      respond_to do |format|
        format.html {render :index}
        format.js {render :search}
      end
    else
      @inventories = @current_user.inventories.where(archive: false).order(tag: :desc)
      render :user_inventory
    end
  end

  # GET /inventory/1
  # GET /inventory/1.json
  def show
    if @inventory.nil?
      flash[:warning] = t(:inventory_does_not_exist)
      redirect_to inventories_path
    end
  end

  def search
    f = params[:filter]
    if f == "arch"
      @inventories = Inventory.where(archive: true).page params[:page]
    else
      users=User.arel_table
      @users = User.where(
          users[:username].matches("%#{f}%")
              .or(users[:name].matches("%#{f}%"))
      ).ids
      kinds=Kind.arel_table
      @kinds = Kind.where(kinds[:description].matches("%#{f}%")).ids
      vendors=Vendor.arel_table
      @vendors = Vendor.where(vendors[:title].matches("%#{f}%")).ids
      inventories=Inventory.arel_table
      @inventories = Inventory.where(archive: false).where(
          inventories[:tag].matches("%#{f}%")
              .or(inventories[:model].matches("%#{f}%"))
              .or(inventories[:serial].matches("%#{f}%"))
              .or(inventories[:user_id].in(@users))
              .or(inventories[:kind_id].in(@kinds))
              .or(inventories[:vendor_id].in(@vendors))
      ).page params[:page]
    end
  end

  def reset
    @inventories = Inventory.order(date_of_purchase: :desc).page params[:page]
    render :search
  end

  def autocomplete
    @inventories = Inventory.where("model like ?", "%#{params["term"]}%")
    respond_to do |format|
      format.json {render json: @inventories.map(&:model)}
    end
  end
  # GET /inventory/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventory/1/edit
  def edit
  end

  # POST /inventory
  # POST /inventory.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: "#{t(:inventory)} #{t(:was_successfully_created)}." }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory/1
  # PATCH/PUT /inventory/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to @inventory, notice: "#{t(:inventory)} #{t(:was_successfully_updated)}." }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory/1
  # DELETE /inventory/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventory_index_url, notice: "#{t(:inventory)} #{t(:was_successfully_destroyed)}." }
      format.json { head :no_content }
    end
  end

  def switch
    status = !@inventory.archive
    if status
      notice = "#{t(:inventory)} #{t(:was_successfully_archived)}."
    else
      notice = "#{t(:inventory)} #{t(:was_successfully_restored)}."
    end
    @inventory.update_attribute(:archive, status)
    redirect_to inventories_path, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      if @current_user.is_admin?
        @inventory = Inventory.find(params[:id])
      else
        inventory = @current_user.inventories.where(id: params[:id])
        inventory.count > 0 ? @inventory = inventory.first : @inventory = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:tag, :model, :serial, :date_of_purchase, :date_of_registration, :notes, :user_id, :kind_id, :vendor_id, :old_id)
    end

    def set_kinds_vendors_and_users
      @kinds = Kind.all.inject([]){|res, k| res << [k.description,k.id]}
      @vendors = Vendor.all.inject([]){|res, v| res << [v.title,v.id]}
      @users = User.all.inject([]){|res, u| res << [u.name,u.id]}
    end

    def set_layout
      if @current_user.is_admin? or @read_only
        self.class.layout "application"
      else
        self.class.layout "user"
      end
    end

    def check_authorization
      if current_user.is_admin?
        true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to inventories_path
      end
    end

    def make_backup
      Backup.generate
    end
end

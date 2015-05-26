require 'digest/sha2'
require 'csv'
class Backup < ActiveRecord::Base
  validates_uniqueness_of :file, :digest
  before_destroy :delete_backup_if_exist
  class << self
    def generate
      @csv_to_export = CSV.generate do |csv|
        csv << ['id', 'tag', 'model', 'serial', 'notes', 'date_of_purchase', 'date_of_registration', 'archive', 'user_name', 'kind_of_inventory', 'vendor_title']
        Inventory.order(:id).each{|i|
          csv << [i.id, i.tag, i.model, i.serial, i.notes, i.date_of_purchase, i.date_of_registration, i.archive, i.user.name, i.kind.description, i.vendor.title]
        }
      end
      @digest = Digest::SHA512.hexdigest @csv_to_export
      Backup.count == 0 ? number = 0 : number = Backup.maximum(:id).next
      @backup = Backup.where(digest: @digest).first
      if @backup
        Backup.unset_current
        @backup.update_attributes(current: true)
        %x(cd #{Settings.csv.path} && rm -f current.csv && ln -s #{@backup.file} current.csv)
      else
        @file = "inventory_#{Date.today.to_s}_#{number}.csv"
        begin
          size = File.write(Backup.path(@file), @csv_to_export)
          if size
            backup = Backup.create(file: @file, digest: @digest)
            if backup
              Backup.unset_current
              backup.update_attributes(current: true, size: size)
            end
          end
          %x(cd #{Settings.csv.path} && rm -f current.csv && ln -s #{@file} current.csv)
        rescue => e
          puts e.message
        end
      end
    end
    def rollback_to(backup)
      Backup.rollback_from_file(Backup.path backup.file)
    end
    handle_asynchronously :generate
    handle_asynchronously :rollback_to
  end

  def self.rollback_from_file(file)
    digest = Digest::SHA512.hexdigest(File.read file)
    @backup = Backup.find_by(digest: digest)
    puts "This file was recognized as backup id: #{@backup.id}" if @backup
    begin
      csv = File.open file, 'r:UTF-8'
      csv.each_with_index do |raw, idx|
        next if idx == 0
        item = raw.parse_csv
        purchase = item[5].to_date if item[5]
        registration = item[6].to_date if item[6]
        item[7] == "true" ? archive = true : archive = false
        params = {
          tag: item[1],
          model: item[2],
          serial: item[3],
          notes: item[4],
          date_of_purchase: purchase,
          date_of_registration: registration,
          archive: archive
        }
        inventory = Inventory.find_by(tag: params[:tag])
        if inventory
          inventory.update_attributes params
          puts "Inventory id: #{inventory.id}, tag: #{inventory.tag} was successfully updated..."
        else
          puts "Inventory with tag: #{params[:tag]} doesn't exist!!!"
        end
      end
    rescue => e
      puts "Something went wrong. Error message: #{e.message}"
      return 1
    end
    if @backup
      Backup.unset_current
      @backup.update_attributes(current: true)
      %x(cd #{Settings.csv.path} && rm -f current.csv && ln -s #{@backup.file} current.csv)
    else
      Backup.generate
    end
  end

  def self.path(file)
    [Rails.root, Settings.csv.path, file].join("/")
  end

  def self.unset_current
    Backup.where(current: true).update_all(current: false)
  end

  def archive?(str)
    str == "true" ? true : false
  end

  private
  def delete_backup_if_exist
    %x(rm -f #{Backup.path(self.file)})
  end

  def set_maintenance
    %x(echo "<h1 style='text-align: center;'>Inventory application is on maintenance.</h1>
    <h2 style='text-align: center;'>Refresh page after few minutes, please.</h2>" > #{Rails.root}/public/maintenance.html)
  end

  def remove_maintenance
    %x(rm -f #{Rails.root}/public/maintenance.html)
  end
end

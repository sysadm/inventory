require 'spec_helper'
require 'rails_helper'
describe 'Autocomplete inventory tests.',js:true, feature:true do
  let! (:admin) {create(:admin)}
  let! (:kind) {create_list(:kind,3)}
  let! (:vendor) {create_list(:vendor,3)}
  let! (:department) {create_list(:department,3)}
  let! (:user) {
    create(:login_user)
    create(:admin_user)
    create(:admin_login_user)
    create(:default_user)
  }
  let! (:inventory){create(:inventory_old)}
  before do
    I18n.locale = :en
    login_with(admin)
    visit inventories_path
  end
  it 'Testing model autocomplete. When we write\'mode\' and press arrow down and enter, should fill correct ' do
    click_link 'New'
    filling_inventories
    model_name = Inventory.last.model
    fill_autocomplete('inventory_model',with: 'mode')
    click_button 'Create Inventory'
    page.should have_content(model_name)
  end
  it 'Testing select2 user autocomplete. When we write \' name \' should suggest list of users. We pick last of them ' do
    click_link 'New'
    filling_inventories
    fill_in 'inventory_model', with: 'model'
    select2(User.last.name,'#s2id_inventory_user_id')
    click_button 'Create Inventory'
    page.should have_content(User.last.name)
  end
  it 'Testing select2 user autocomplete. When we write \' name \' should suggest list of users. We pick first of them ' do
    click_link 'New'
    filling_inventories
    fill_in 'inventory_model', with: 'model'
    select2(User.first.name,'#s2id_inventory_user_id')
    click_button 'Create Inventory'
    page.should have_content(User.first.name)
  end
  it 'Testing select2 kind autocomplete. When we write \' kind.description \' should suggest list of users. We pick
      last of them ' do
    click_link 'New'
    filling_inventories
    fill_in 'inventory_model', with: 'model'
    select2(Kind.last.description,'#s2id_inventory_kind_id')
    click_button 'Create Inventory'
    page.should have_content(Kind.last.description)
  end
  it 'Testing select2 kind autocomplete. When we write \' kind.description \' should suggest list of users. We pick
      first of them ' do
    click_link 'New'
    filling_inventories
    fill_in 'inventory_model', with: 'model'
    select2(Kind.first.description,'#s2id_inventory_kind_id')
    click_button 'Create Inventory'
    page.should have_content(Kind.first.description)
  end
  it 'Testing select2 vendor autocomplete. When we write \' vendor.title \' should suggest list of users. We pick
      last of them ' do
    click_link 'New'
    filling_inventories
    fill_in 'inventory_model', with: 'model'
    select2(Vendor.last.title,'#s2id_inventory_vendor_id')
    click_button 'Create Inventory'
    page.should have_content(Vendor.last.title)
  end
  it 'Testing select2 vendor autocomplete. When we write \' vendor.title \' should suggest list of users. We pick
      first of them ' do
    click_link 'New'
    filling_inventories
    fill_in 'inventory_model', with: 'model'
    select2(Vendor.first.title,'#s2id_inventory_vendor_id')
    click_button 'Create Inventory'
    page.should have_content(Vendor.first.title)
  end
end
def filling_inventories
  fill_in 'inventory_tag', with: 'TestTag'
  fill_in 'inventory_serial', with: 'TestSerial'
  fill_in 'inventory_notes', with: 'TestNotes'
  fill_in 'inventory_date_of_purchase', with: Time.now.to_date
  fill_in 'inventory_date_of_registration', with: Time.now.to_date
end

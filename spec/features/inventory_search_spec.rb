require 'spec_helper'
require 'rails_helper'
describe 'Inventory search script should work correct.', js:true, feature: true do
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
  let! (:inventory){create_list(:inventory,5)}
  before :each do
    I18n.locale = :en
    login_with(admin)
    visit root_path
    path = '/html/body/div[2]/div/div[2]/table/tbody/'
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
  end
  it 'By default should display only 3 inventories' do
    page.should have_content('tag',count:3)
  end
  # it 'If we write 2 letters should still display 3 inventories' do
  #   fill_in 'filter', :with => 'ta'
  #   sleep 2
  #   page.should have_content('tag',count:3)
  # end
  it 'If we write arch, should show 2 archived results' do
    visit root_path
    filter = find('#filter')
    filter.set('arch')
    filter.native.send_keys :enter
    sleep 1
    page.should have_content('tag',count:2)
    find('#filter-clear').click unless selenium?
  end
  it 'If we write full tagname, should display only one result' do
    visit root_path
    filter = find('#filter')
    filter.set(Inventory.where(archive: false).last.tag)
    filter.native.send_keys :enter
    page.should have_content('tag',count:1)
    find('#filter-clear').click unless selenium?
  end
  it 'If we write wrong tagname, should display nothing' do
    visit root_path
    # fill_in 'filter', :with => 'wronk444'
    filter = find('#filter')
    filter.set('wronk404')
    filter.native.send_keys :enter
    sleep 1
    page.should have_content('tag',count:0)
    find('#filter-clear').click unless selenium?
  end
  it 'Should search by model' do
    visit root_path
    filter = find('#filter')
    filter.set(Inventory.where(archive: false).last.model)
    filter.native.send_keys :enter
    sleep 1
    page.should have_content('model',count:1)
    find('#filter-clear').click unless selenium?
  end
  it 'Should search by serial' do
    visit root_path
    filter = find('#filter')
    filter.set(Inventory.where(archive: false).last.serial)
    filter.native.send_keys :enter
    sleep 1
    page.should have_content('serial',count:1)
    find('#filter-clear').click unless selenium?
  end
end
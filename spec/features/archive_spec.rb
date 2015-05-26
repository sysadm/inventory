require 'spec_helper'
require 'rails_helper'
describe 'Archiving inventories, vendors, kinds, departments.' do
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
  let! (:inventory){create_list(:inventory,3)}
  before :each do
    I18n.locale = :en
    login_with(admin)
  end
  it 'Should archive inventory, and display it correct', js: true, feature: true do
    path = '/html/body/div[2]/div/div[2]/table/tbody/'
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('tag', count: 1)
    visit root_path
    filter = find('#filter')
    filter.set('arch')
    filter.native.send_keys :enter
    sleep 1
    page.should have_content('tag', count: 2)
    find(:xpath, path+"tr[1]").click_link('Restore')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('tag', count: 2)
  end
  it 'Should archive kinds, and display it by button click', js: true, feature: true do
    path = '/html/body/div/div/table/tbody/'
    visit kinds_path
    page.should have_content('desc', count:3)
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('desc', count:1)
    click_link 'Archive index'
    page.should have_content('desc', count:2)
    find(:xpath, path+"tr[1]").click_link('Restore')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('desc', count:2)
  end
  it 'Should archive vendors, and display it by button click', js: true, feature: true do
    path = '/html/body/div/div/table/tbody/'
    visit vendors_path
    page.should have_content('title', count: 3)
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('title', count: 1)
    click_link 'Archive index'
    page.should have_content('title', count: 2)
    find(:xpath, path+"tr[1]").click_link('Restore')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('title', count: 2)
  end
  it 'Should archive departments, and display it by button click', js: true, feature: true do
    path = '/html/body/div/div/table/tbody/'
    visit departments_path
    page.should have_content('title', count: 3)
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('title', count: 1)
    click_link 'Archive index'
    page.should have_content('title', count: 2)
    find(:xpath, path+"tr[1]").click_link('Restore')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('title', count: 2)
  end
  it 'Should archive users, and display it by button click', js: true, feature: true do
    path = '/html/body/div/div/table/tbody/'
    visit users_path
    page.should have_content('username', count: 4)
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    find(:xpath, path+"tr[1]").click_link('Archive')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('username', count: 2)
    click_link 'Archive index'
    page.should have_content('username', count: 2)
    find(:xpath, path+"tr[1]").click_link('Restore')
    page.driver.browser.switch_to.alert.accept if selenium?
    page.should have_content('username', count: 3)
  end
end
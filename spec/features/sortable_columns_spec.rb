require 'spec_helper'
require 'rails_helper'
describe 'Inventory sorting by columns.', js:true, feature: true do
  let! (:admin) {create(:admin)}
  let! (:kind) {create_list(:kind,4)}
  let! (:vendor) {create_list(:vendor,4)}
  let! (:department) {create_list(:department,4)}
  let! (:user) {
    create(:login_user)
    create(:admin_user)
    create(:admin_login_user)
    create(:default_user)
  }
  let! (:inventory1){create(:for_sort_inventory,tag:"tagga",model: "modella",user: user, vendor: vendor[0], kind: kind[0])}
  let! (:inventory2){create(:for_sort_inventory,tag:"taggb",model: "modellb",user: user, vendor: vendor[0], kind: kind[0])}
  let! (:inventory3){create(:for_sort_inventory,tag:"taggc",model: "modellc",user: user, vendor: vendor[0], kind: kind[0])}
  let! (:inventory4){create(:for_sort_inventory,tag:"tagx",model: "modelx",user: user, vendor: vendor[0], kind: kind[0])}

  before :each do
    I18n.locale = :en
    login_with(admin)
    visit root_path
    @path = '/html/body/div/div/div[2]/table/tbody/'
  end
  it 'Should sorted all by tag desc/asc/desc' do
    find(:xpath, @path+"tr[1]").should have_content inventory4.tag
    click_link 'Tag'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory1.tag
    click_link 'Tag'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory4.tag
  end
  it 'Should sorted all by model desc/asc/desc' do
    click_link 'Model'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory4.model
    click_link 'Model'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory1.model
    click_link 'Model'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory4.model
  end
  it 'Should sorted filtered inventory by tag desc/asc/desc' do
    filter = find('#filter')
    filter.set('tagg')
    filter.native.send_keys :enter
    find(:xpath, @path+"tr[1]").should have_content inventory3.tag
    click_link 'Tag'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory1.tag
    click_link 'Tag'
    sleep 1
    find(:xpath, @path+"tr[1]").should have_content inventory3.tag
  end
end

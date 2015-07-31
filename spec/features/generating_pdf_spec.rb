require 'spec_helper'
require 'rails_helper'
describe 'Generating pdf for inventory item. ' do
  let! (:admin) {create(:admin)}
  let! (:kind) {create_list(:kind,3)}
  let! (:vendor) {create_list(:vendor,3)}
  let! (:department) {create_list(:department,3)}
  let! (:user) {create(:default_user)}
  let! (:inventory){create(:inventory_new,user: user, vendor: vendor[0], kind: kind[0])}
  before do
    I18n.locale = :en
    login_with(admin)
    visit inventories_path
  end
  it 'Page should have pdf icon' do
    page.should have_css('.pdf-inactive')
  end

  it 'Pdf should have correct data' do
    visit generate_pdf_path(Inventory.last,'pdf')
    temp_pdf = Tempfile.new('pdf')
    temp_pdf << page.source.force_encoding('UTF-8')
    temp_pdf.close
    pdf_text = PDF::PdfToText.new(temp_pdf.path)
    page.driver.response.instance_variable_set('@body', [pdf_text.get_text])
    page.should have_content(Inventory.last.tag)
    page.should have_content(Time.now.strftime("%d/%m/%Y"))
    page.should have_content(User.last.first_name)
    page.should have_content(User.last.last_name)
  end

  it 'Should give a ok status code' do
    visit generate_pdf_path(Inventory.last,'pdf')
    page.status_code == 200
  end

end
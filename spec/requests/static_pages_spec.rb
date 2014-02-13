require 'spec_helper'

describe "Static pages" do

  let(:base_title) {"Ruby on Rails Tutorial Sample App"}

  subject {page}

  describe "Home page" do 
    before{ visit root_path}

    it {should have_content("Sample App")}
    it {should have_title(full_title(''))}
    it {should_not have_title("| Home")}
#    it "should have the content 'Sample App'" do
#      expect(page).to have_content('Sample App')
#    end
#    it "should have the right title" do 
#      expect(page).to have_title(base_title)
#    end
  end
  
  describe "Help Page" do 
    before { visit help_path}

    it {should have_content("Help")}
    it {should have_title(full_title("Help"))}
    #it "Should have the content 'Help'" do
    #  visit help_path
    #  expect(page).to have_content('Help')
    #end
    #it "Should have the right title" do 
    #  visit help_path
    #  expect(page).to have_title("#{base_title} | Help")
    #end
  end
  
  describe "About Page" do
    before { visit about_path}

    it { should have_content("About Us")}
    it { should have_title(full_title("About Us"))}

  end
  
  describe "Contact Page" do 
    before {visit contact_path}

    it { should have_content("andrewjmeyers28@gmail.com")}
    it { should have_title(full_title("Contact"))} 
  end
end

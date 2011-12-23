# encoding: UTF-8

require 'dummy_spec_helper'

module DeviseSessionHelpers
  def login_with email, password
    fill_in       "Email",    :with => email
    fill_in       "Password", :with => password
    click_button  "Sign in"
  end

  def login_user
    visit new_user_session_path
    login_with 'stanislaw@gmail.com', "666666"
  end
end

feature "Carrier", %q{
  In order to have github-like messaging functionality
  As an user
  I want to do create, receive, list and archive messages} do

  background do
    Capybara.reset_sessions!
    load_seeds

    login_user
  end

  include DeviseSessionHelpers
  
  scenario "Inbox: listing messages" do
    visit '/carrier/messages'
    
    page.should_not have_content("message#1")
    page.should have_content("message#2")
    page.should_not have_content("message#3")
    page.should have_content("message#4")
  end

  scenario "Sent: listing messages" do
    visit '/carrier/messages/sent'
    page.should_not have_content("message#1")
    page.should have_content("message#2")
    page.should have_content("message#3")
    page.should_not have_content("message#4")
  end

  scenario "Creating a message" do
    visit "/carrier/messages"
    click_link "New"
 
    select 'marixa', :from => "Recipients"
    select 'miloviza', :from => "Recipients"

    fill_in "Subject", :with => "Тема тестового сообщения"
    fill_in "Message", :with => "тестовое сообщение"

    click_button("Send")

    page.should have_content("marixa")
    page.should have_content("miloviza")
    page.should have_content("Reply into thread")
  end

  scenario "Archiving a message", :js => true do
    visit "/carrier/messages/#{Carrier::Message.last.id}"
    click_link "Archive!"
  
    page.should have_content("Unarchive?")
  end
end


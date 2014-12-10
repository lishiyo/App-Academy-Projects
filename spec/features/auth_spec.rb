require 'rails_helper'

feature "the signup process" do

  before(:each) do
    visit new_user_url
  end

  scenario "it has a user sign up page" do
    expect(page).to have_content("Sign Up")
  end

  scenario "it takes a username and password" do
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  scenario "it validates the presence of the user's username" do

    click_button 'Sign Up'
    expect(page).to have_content 'Sign Up'
    expect(page).to have_content "Username can't be blank"
  end

  scenario "it rejects a missing password" do
    fill_in "username", with: 'test_user'
    click_button 'Sign Up'
    expect(page).to have_content 'Sign Up'
    expect(page).to have_content "Password is too short"
  end

  scenario "it rejects a password under 6 characters" do
    fill_in "username", with: 'test_user'
    fill_in 'password', with: 'pass'
    click_button 'Sign Up'
    expect(page).to have_content 'Sign Up'
    expect(page).to have_content "Password is too short"
  end

  feature "signing up a user" do

    before(:each) do
      sign_up_as_test
    end

    scenario "redirects to user's show page after signup" do
      expect(page).to have_content "test_user"
    end

    scenario "shows username on every page after signup" do
      visit root_url
      expect(page).to have_content "test_user"
    end

  end

end


feature "logging in" do

  before(:each) do
    sign_up_as_test
    sign_in("test_user")
  end

  scenario "shows username on the homepage after login" do
    expect(page).to have_content "test_user"
  end

end

feature "logging out" do
  before(:each) do
    sign_up_as_test
  end

  scenario "begins with logged out state" do
    click_button "Sign Out"
    expect(page).to have_content "Sign In"
    expect(page).to_not have_content "Sign Out"
  end

  scenario "doesn't show username on the homepage after logout" do
    click_button "Sign Out"
    expect(page).to_not have_content "test_user"
    expect(page).to_not have_content "password"
  end

end

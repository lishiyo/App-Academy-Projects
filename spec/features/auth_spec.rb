require 'rails_helper'

feature "the signup process" do

  scenario "it has a new user page" do
    visit new_user_url
    expect(page).to have_content("Sign Up")
  end


  feature "signing up a user" do
    before(:each) do
      sign_up_as_test
    end

    scenario "redirects to homepage after signup" do
      expect(page).to have_content "Homepage"
    end

    scenario "shows username on the homepage after signup" do
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
    expect(page).to have_content "Sign In"
    expect(page).to not_have_content "Sign Out"
  end

  scenario "doesn't show username on the homepage after logout" do
    click_button "Sign Out"
    expect(page).to not_have_content "test_user"
    expect(page).to not_have_content "password"
  end

end

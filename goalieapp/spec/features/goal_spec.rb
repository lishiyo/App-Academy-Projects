require 'rails_helper'

feature "goals" do

  feature "goal creation" do
    scenario "must be logged in to create new goal" do
      visit root_url
      expect(page).to_not have_content("Create New Goal")
      expect(page).to have_content("Sign Up")
    end

    scenario "it has a goal creation form on the user's show page" do
      @user = FactoryGirl.build(:user)
      visit user_url(@user)
      expect(page).has_css?('form#create-goal')
      expect(page).to have_content("Create New Goal")
    end

    scenario "it validates the presence of ..." do

    end

    scenario "it displays the new goals on the user's show page" do

    end

  end

  feature "goal editing" do

    scenario "it has an Edit button beside each goal on the user's show page" do

    end

    scenario "it goes to the Edit page for the goal you clicked" do

    end

    scenario "after a successful edit, redirects to user's show page with updated goal" do

    end

    scenario "it has an edit button on the goal's own show page" do

    end

  end

  feature "goal deletion" do

    scenario "has a delete button beside each goal on the user's show page" do

    end

    scenario "upon successful deletion, re-renders user's show page without the goal" do

    end

  end

  feature "goal privacy" do

    scenario "can check column as public" do



    end

    feature "public goals" do

      scenario "can be seen by anyone who is logged in" do

      end

    end

    feature "private goals" do

      scenario "can only be seen by the creator" do

      end

    end

  end

  feature "goal completion" do
    scenario "can be marked as completed" do

    end

    scenario "shows proper completion status at all times" do

    end

    scenario "punishes user for not completing goals by deadline" do

    end


  end


end

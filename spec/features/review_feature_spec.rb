require 'rails_helper'

feature 'reviewing' do

	before do
		user_signin
		add_restaurant("Richies Cantina")
		click_link 'Review Richies Cantina'
		fill_in 'Gripes', with: "scary, but rather marvelous music"
		select '4', from: 'Rating'
		click_button 'Leave Review'
	end

	scenario 'allows users to leave reviews using a form' do
		expect(current_path).to eq '/restaurants'
		expect(page).to have_content("scary, but rather marvelous music")
	end

	scenario 'removes reviews when restaurants are deleted' do
		click_link 'Delete Richies Cantina'
		expect(current_path).to eq '/restaurants'
		expect(page).not_to have_content("scary, but rather marvelous music")
	end

	scenario 'can only be deleted by the authour' do
		click_link('Sign out')
		click_link('Sign up')
		fill_in('Email', with: 'chris@example.com')
		fill_in('Password', with: 'christest')
		fill_in('Password confirmation', with: 'christest')
		click_button('Sign up')
		expect(page).not_to have_link('Delete Richies Cantina Review')
	end

end
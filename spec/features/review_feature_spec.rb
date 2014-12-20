require 'rails_helper'

feature 'reviewing' do

	before do
		user_signin
		add_restaurant("Richies Cantina")
	end

	scenario 'allows users to leave reviews using a form' do
		leave_review("scary, but rather marvelous music", '4')
		expect(current_path).to eq '/restaurants'
		expect(page).to have_content("scary, but rather marvelous music")
	end

	scenario 'removes reviews when restaurants are deleted' do
		click_link 'Delete Richies Cantina'
		expect(current_path).to eq '/restaurants'
		expect(page).not_to have_content("scary, but rather marvelous music")
	end

	scenario 'displaying an average rating for all reviews' do
		leave_review('So, so', '3')
		leave_review('Great', '5')
		expect(page).to have_content('★★★★☆')
	end

	scenario 'display when they are created relative to now' do
		leave_review('Lovely', '4')
		expect(page).to have_content('Posted')
	end

	scenario 'deleting a review' do
		leave_review('Lovely jubly', '5')
		click_link('Delete review')
		expect(page).not_to have_content('Lovely jubly')
		expect(page).to have_content('Richies Cantina')
	end

	scenario 'attempting to delete a review that you did not write' do
		leave_review('Lovely jubly', '5')
		click_link('Sign out')
	  click_link('Sign up')
	  fill_in('Email', with: 'test2@example2.com')
	  fill_in('Password', with: 'test2test2')
	  fill_in('Password confirmation', with: 'test2test2')
	  click_button('Sign up')
	  expect(page).not_to have_link('Delete review')
	end

end
require 'rails_helper'

feature 'reviewing' do

	before {Restaurant.create name: 'Richies Cantina'}

	scenario 'allows users to leave reviews using a form' do
		visit '/restaurants'
		click_link 'Review Richies Cantina'
		fill_in 'Gripes', with: "scary, but rather marvelous music"
		select '4', from: 'Rating'
		click_button 'Leave Review'
		expect(current_path).to eq '/restaurants'
		expect(page).to have_content("scary, but rather marvelous music")
	end

	scenario 'removes reviews when restaurants are deleted' do
		visit '/restaurants'
		click_link 'Review Richies Cantina'
		fill_in 'Gripes', with: "scary, but rather marvelous music"
		select '4', from: 'Rating'
		click_button 'Leave Review'
		click_link 'Delete Richies Cantina'
		expect(current_path).to eq '/restaurants'
		expect(page).not_to have_content("scary, but rather marvelous music")
	end

end
require 'rails_helper'

feature 'restaurants' do

	context 'no restaurants have been added' do
		scenario 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content 'No restaurants'
			expect(page).to have_link 'Add a restaurant'
		end

	end

	context 'restaurants have been added' do

		before do
			Restaurant.create(name: 'Crispys Palace')
		end

		scenario 'display restaurants' do
			visit '/restaurants'
			expect(page).to have_content('Crispys Palace')
			expect(page).not_to have_content('No restaurants yet')
		end

	end

	context 'creating restaurants' do

		scenario 'prompt user to fill out a form, then displays new restaurant' do
			visit '/restaurants' 
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'Crispys Palace'
			click_button 'Create Restaurant'
			expect(page).to have_content 'Crispys Palace'
			expect(current_path).to eq '/restaurants'
		end

	end

end
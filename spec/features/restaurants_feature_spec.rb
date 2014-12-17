require 'rails_helper'

def user_signin
	visit('/')
	click_link('Sign up')
	fill_in('Email', with: 'test@example.com')
	fill_in('Password', with: 'testtest')
	fill_in('Password confirmation', with: 'testtest')
	click_button('Sign up')
end

feature 'restaurants' do

	context 'no restaurants have been added' do
		scenario 'should display a prompt to add a restaurant' do
			user_signin
			expect(page).to have_content 'No restaurants'
			expect(page).to have_link 'Add a restaurant'
		end

	end

	context 'restaurants have been added' do

		before { Restaurant.create(name: 'Crispys Palace') }

		scenario 'display restaurants' do
			visit '/restaurants'
			expect(page).to have_content('Crispys Palace')
			expect(page).not_to have_content('No restaurants yet')
		end

	end

	context 'creating restaurants' do

		scenario 'prompt user to fill out a form, then displays new restaurant' do
			user_signin
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'Crispys Palace'
			click_button 'Create Restaurant'
			expect(page).to have_content 'Crispys Palace'
			expect(current_path).to eq '/restaurants'
		end

		scenario 'the system is not inventive enough to allow a restaurant to have an edgy shoreditch name' do
			user_signin
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'cb'
			click_button 'Create Restaurant'
			expect(page).not_to have_css 'h2', text: 'cb'
			expect(page).to have_content 'error'
		end

	end

	context 'viewing restaurants' do

		let!(:cp ){ Restaurant.create(name:'Crispys Palace') }

		scenario 'lets a user view a restaurant' do
			visit '/restaurants'
			click_link 'Crispys Palace'
			expect(page).to have_content 'Crispys Palace'
			expect(current_path).to eq "/restaurants/#{cp.id}"
		end

	end

	context 'editing restaurants' do

		before { Restaurant.create name:'Crispys Palace' }

		scenario 'let a user edit a restaurant' do
			user_signin
			click_link 'Edit Crispys Palace'
			fill_in 'Name', with: 'Crispys Hovel'
			click_button 'Update Restaurant'
			expect(page).to have_content 'Crispys Hovel'
			expect(current_path).to eq '/restaurants'
		end

	end

	context 'deleting restaurants' do

		before { Restaurant.create(:name => "Crispy Palace") }

		scenario 'removes a restaurant when a user clicks a delete link' do
			user_signin
			click_link 'Delete Crispy Palace'
			expect(page).not_to have_content 'Crispy Palace'
			expect(page).to have_content 'Restaurant deleted successfully'
		end

	end

end
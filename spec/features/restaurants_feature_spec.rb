require 'rails_helper'

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
			add_restaurant("Crispys Palace")
			expect(page).to have_content 'Crispys Palace'
			expect(current_path).to eq '/restaurants'
		end

		scenario 'with a description' do
			user_signin
			click_link 'Add a restaurant'
  		fill_in 'Name', with: "Crispys Palace"
  		fill_in "Description", with: "Modern Rural Cuisine"
  		click_button 'Create Restaurant'
  		expect(page).to have_content("Modern Rural Cuisine")
		end

		scenario 'creating a restaurant and supplying an image' do
			user_signin
			click_link 'Add a restaurant'
  		fill_in 'Name', with: "Rich's Radish"
  		attach_file('restaurant[image]', 'spec/features/a-radish.jpg')
  		click_button 'Create Restaurant'
  		expect(page).to have_css("img[src*='a-radish.jpg']")
		end

		scenario 'the tries to create a restaurant with a short name' do
			user_signin
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'cb'
			click_button 'Create Restaurant'
			expect(page).not_to have_css 'h2', text: 'cb'
			expect(page).to have_content 'error'
		end

		it "can only have a restaurant added by a signed in user" do
			visit ('/')
			expect(page).not_to have_link('Add a restaurant')
		end

	end

	context 'viewing restaurants' do

		let!(:crisyps_palace){ Restaurant.create(name:'Crispys Palace') }

		scenario 'lets a user view a restaurant' do
			visit '/restaurants'
			click_link 'Crispys Palace'
			expect(page).to have_content 'Crispys Palace'
			expect(current_path).to eq "/restaurants/#{crisyps_palace.id}"
		end

	end

	context 'editing restaurants' do

		scenario 'let a user edit a restaurant' do
			user_signin
			add_restaurant("Crispys Palace")
			click_link 'Edit Crispys Palace'
			fill_in 'Name', with: 'Crispys Hovel'
			click_button 'Update Restaurant'
			expect(page).to have_content 'Crispys Hovel'
			expect(current_path).to eq '/restaurants'
		end

		scenario 'it will not allow a user to edit a restaurant that they did not create' do
			user_signin
			add_restaurant("Crispys Palace")
			click_link('Sign out')
			click_link('Sign up')
			fill_in('Email', with: 'rich@example.com')
			fill_in('Password', with: 'testrich')
			fill_in('Password confirmation', with: 'testrich')
			click_button('Sign up')
			expect(page).not_to have_link('Edit Crispys Palace')
		end

	end

	context 'deleting restaurants' do

		scenario 'removes a restaurant when a user clicks a delete link' do
			user_signin
			add_restaurant("Crispys Palace")
			click_link 'Delete Crispys Palace'
			expect(page).not_to have_content 'Crispys Palace'
			expect(page).to have_content 'Restaurant deleted successfully'
		end

		scenario 'trying to remove a restaurant that you didnt create' do
			user_signin
			add_restaurant("Crispys Palace")
			click_link('Sign out')
			click_link('Sign up')
			fill_in('Email', with: 'rich@example.com')
			fill_in('Password', with: 'testrich')
			fill_in('Password confirmation', with: 'testrich')
			click_button('Sign up')
			expect(page).not_to have_link('Delete Crispys Palace')
		end

	end

	describe '#average_rating' do

		context 'no reviews' do

			it 'returns N/A when there are no reviews' do
				restaurant = Restaurant.create(name: 'The Ivy')
				expect(restaurant.average_rating).to eq 'N/A'
			end

		end

		context 'One review' do

			it 'returns the rating' do
				restaurant = Restaurant.create(name: 'The Ivy')
				restaurant.reviews.create(rating: 4)
				expect(restaurant.average_rating).to eq(4)
			end

		end

		context 'Multiple reviews' do

			it 'returns the average' do
				restaurant = Restaurant.create(name: 'The Ivy')
				restaurant.reviews.create(rating: 1)
				restaurant.reviews.create(rating: 5)
				expect(restaurant.average_rating).to eq(3)
			end

		end
		
	end

end


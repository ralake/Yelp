def user_signin
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'test@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end

def add_restaurant(name)
  click_link 'Add a restaurant'
  fill_in 'Name', with: "#{name}"
  click_button 'Create Restaurant'
end

def leave_review(gripes, rating)
  visit '/restaurants'
  click_link 'Review Richies Cantina'
  fill_in 'Gripes', with: gripes
  select rating, from: 'Rating'
  click_button 'Leave Review'
end
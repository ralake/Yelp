class ReviewsController < ApplicationController

	def new
	  @restaurant = Restaurant.find(params[:restaurant_id])
	  @review = Review.new
	end

	def create
	  @restaurant = Restaurant.find(params[:restaurant_id])
	  params[:review][:user_id] = current_user.id
	  @restaurant.reviews.create(review_params)
	  redirect_to restaurants_path
	end

	def review_params
	  params.require(:review).permit(:gripes, :rating, :user_id)
	end

	 def destroy
	 	@restaurant = Restaurant.find(params[:restaurant_id])
	 	@review = Review.find_by(:restaurant_id => @restaurant.id)
    @review.destroy
    flash[:notice] = "Review deleted successfully"
    redirect_to '/restaurants'
  end

end

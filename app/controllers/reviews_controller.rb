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

	def destroy
	 	@review = Review.find(params[:id])
		if !current_user || current_user.id != @review.user_id
			flash[:notice] = "You are not allowed to delete this review"
    	redirect_to '/restaurants'
    else
	    @review.destroy
	    flash[:notice] = "Review deleted successfully"
	    redirect_to '/restaurants'
    end
  end

	def review_params
	  params.require(:review).permit(:gripes, :rating, :user_id, :restaurant_id, :id)
	end

end

class Api::V1::PostRatingController < ApplicationController
  before_action :set_post_rating, only: [:show, :update]

  # Shows the post/thread rating
  def show
    post_ratings = PostRating.where(post_id: params[:post_rating][:post_id])
    user_rating = PostRating.find_by(user_id: params[:post_rating][:user_id], post_id: params[:post_rating][:post_id])
    puts post_ratings
    response_data = {
    post_ratings: post_ratings.as_json,
    user_rating: user_rating.as_json,
    }

    render json: response_data
  end

  # Creates and update the post/thread rating
  def update
    if @post_rating.nil?
      # If the post rating doesn't exist, create a new one
      @post_rating = PostRating.create!(post_rating_params)
      if @post_rating
        post = Post.find_by(id: params[:post_rating][:post_id])
        post.update(like_count: post.like_count + params[:post_rating][:rating])
        render json: @post_rating, status: :created
      else
        render json: @post_rating.errors.full_messages, status: :unprocessable_entity
      end
    else
      # If the post rating already exists, update it
      # new rating - old rating
      sum = params[:post_rating][:rating] - @post_rating.rating
      puts sum
      if @post_rating.update(post_rating_params)
        post = Post.find_by(id: params[:post_rating][:post_id])
        post.update(like_count: post.like_count + sum)
        render json: @post_rating, status: :ok
      else
        render json: @post_rating.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  private

  # Sets the parameters for post rating
  def post_rating_params
    params.require(:post_rating).permit(:user_token, :post_id, :rating, :user_id)
  end

  # Sets the post/thread ratings
  def set_post_rating
    token = params[:post_rating].delete(:user_token)
    #need check for existence of token, possibility that user is not logged in.
    if token.present?
      decoded_token = JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      user_id_from_token = decoded_token.first["user_id"]
      @post_rating = PostRating.find_by(user_id: user_id_from_token, post_id: params[:post_rating][:post_id])
      # Add user_id back to params
      params[:post_rating][:user_id] = user_id_from_token
    else
      @post_rating = PostRating.find_by(post_id: params[:post_rating][:post_id])
    end
  end

  # Sets the jwt key
  def jwt_key
    Rails.application.credentials.jwt_key
  end
end

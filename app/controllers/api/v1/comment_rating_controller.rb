class Api::V1::CommentRatingController < ApplicationController
  before_action :set_comment_rating, only: [:show, :update]

  def show
    comment_ratings = CommentRating.where(comment_id: params[:comment_rating][:comment_id])
    user_rating = CommentRating.find_by(user_id: params[:comment_rating][:user_id], comment_id: params[:comment_rating][:comment_id])
    puts comment_ratings
    response_data = {
    comment_ratings: comment_ratings.as_json,
    user_rating: user_rating.as_json,
    }

    render json: response_data
  end

  def update
    if @comment_rating.nil?
      # If the comment rating doesn't exist, create a new one
      @comment_rating = CommentRating.create!(comment_rating_params)
      if @comment_rating
        comment = Comment.find_by(id: params[:comment_rating][:comment_id])
        comment.update(like_count: comment.like_count + params[:comment_rating][:rating])
        render json: @comment_rating, status: :created
      else
        render json: @comment_rating.errors.full_messages, status: :unprocessable_entity
      end
    else
      # If the comment rating already exists, update it
      # new rating - old rating
      sum = params[:comment_rating][:rating] - @comment_rating.rating
      puts sum
      if @comment_rating.update(comment_rating_params)
        comment = Comment.find_by(id: params[:comment_rating][:comment_id])
        # puts comment.like_count
        comment.update(like_count: comment.like_count + sum)
        render json: @comment_rating, status: :ok
      else
        render json: @comment_rating.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  private

  def comment_rating_params
    params.require(:comment_rating).permit(:user_token, :comment_id, :rating, :user_id)
  end

  def set_comment_rating
    token = params[:comment_rating].delete(:user_token)
    #need check for existence of token, possibility that user is not logged in.
    if token.present?
      decoded_token = JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      user_id_from_token = decoded_token.first["user_id"]
      @comment_rating = CommentRating.find_by(user_id: user_id_from_token, comment_id: params[:comment_rating][:comment_id])
      # Add user_id back to params
      params[:comment_rating][:user_id] = user_id_from_token
    else
      @comment_rating = CommentRating.find_by(comment_id: params[:comment_rating][:comment_id])
    end
  end

  def jwt_key
    Rails.application.credentials.jwt_key
  end
end

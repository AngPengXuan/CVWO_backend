class Api::V1::PostsController < ApplicationController
  # Sets post and comments, and authenticate users before certain paths
  before_action :set_post, only: %i[show destroy update]
  before_action :authenticate_user, only: %i[show create update destroy]
  before_action :set_comments, only: %i[show]

  # Returns all the posts/threads
  def index
    posts = Post.all.order(created_at: :desc)
    posts_with_ratings = posts.map do |post|
      {
        post: post,
        username: User.find_by(id: post.user_id)&.username,
        ratings: post.post_ratings.map { |rating| { user_id: rating.user_id, rating: rating.rating } }
      }
    end

    render json: posts_with_ratings
  end

  # Creation of post/thread
  def create
    puts post_params
    post = Post.create!(post_params)

    if post
      # Create associated post rating for the current user
      post_rating = @current_user.post_ratings.create(post: post, rating: 0)
      render json: { post: post, post_rating: post_rating }
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Updating of post/thread
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Showing a single post/thread with comments
  def show
    user = User.find_by(id: @post.user_id)
    ratings = @post.post_ratings.map { |rating| { user_id: rating.user_id, rating: rating.rating } }

    render json: {
      post: @post.as_json.merge("username" => user&.username),
      comments: @comments_json,
      ratings: ratings,
      is_owner: current_user_is_owner?
    }
  end

  # Destroying the post/thread with associated comments and ratings
  def destroy
    comments = Comment.where(post_id: params[:id])
    comment_ids = comments.pluck(:id)
    comment_ratings = CommentRating.where(comment_id: comment_ids)
    comment_ratings.destroy_all
    comments.destroy_all
    post_ratings = PostRating.where(post_id: params[:id])
    post_ratings.destroy_all
    @post.destroy
    render json: { message: 'Post deleted' }
  end

  private

  # Authenticate the user
  def authenticate_user
    params.permit(:token, :id, post:{})
    token = params[:token]
    decoded_token = JWT.decode(token, jwt_key, true, algorithm: 'HS256')

    if decoded_token && decoded_token[0] && decoded_token[0]['user_id']
      @current_user = User.find_by(id: decoded_token[0]['user_id'])
    else
      @current_user = nil
    end
  rescue JWT::DecodeError => e
    @current_user = nil
  end

  # Gets the jwt_key
  def jwt_key
    Rails.application.credentials.jwt_key
  end

  # Sets the current user
  def current_user
    @current_user
  end

  # Sets the post parameters
  def post_params
    if current_user != nil
      params.require(:post).permit(:title, :category, :content).merge(user_id: current_user.id)
    else
      params.require(:post).permit(:title, :category, :content).merge(user_id: nil)
    end
  end

  # Sets the current post/thread
  def set_post
    params.permit(:id, :token, post: {})
    puts "set"
    @post = Post.find(params[:id])
  end

  # Set the comments associated with the post/thread
  def set_comments
    params.permit(:id, :token, post: {})
    @comments = Comment.where(post_id: params[:id]).order(created_at: :desc)
    @comments_json = @comments.as_json(only: [:id, :content, :created_at, :user_id]).map do |comment|
      user = User.find_by(id: comment["user_id"])
      comment_ratings = CommentRating.where(comment_id: comment["id"])

      comment.merge(
        "username" => user&.username,
        "is_owner" => (user&.id == current_user&.id) ? true : false,
        "comment_ratings" => comment_ratings.as_json()
      )
    end
    puts @comments_json
  end

  # Checks if the current user is owner of the post/thread
  def current_user_is_owner?
    if current_user != nil
      @post.user_id == current_user.id
    else
      return false
    end
  end
end

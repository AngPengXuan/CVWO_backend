class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy update]
  before_action :authenticate_user, only: %i[show create update destroy]

  def index
    posts = Post.all.order(created_at: :desc)
    posts_with_username = posts.map do |post|
      {post: post, username: User.find_by(id: post.user_id)&.username}
    end

    render json: posts_with_username
  end

  def create
    puts post_params
    post = Post.create!(post_params)

    if post
      render json: post
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      post: @post,
      is_owner: current_user_is_owner?
    }
  end

  def destroy
    @post.destroy
    render json: { message: 'Post deleted' }
  end

  private

  def authenticate_user
    params.permit(:token, :id, post:{})
    token = params[:token]
    decoded_token = JWT.decode(token, jwt_key, true, algorithm: 'HS256')

    if decoded_token && decoded_token[0] && decoded_token[0]['user_id']
      @current_user = User.find_by(id: decoded_token[0]['user_id'])
    else
      render json: { error: 'User ID not found in the decoded token' }, status: :unprocessable_entity
    end
  rescue JWT::DecodeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def jwt_key
    Rails.application.credentials.jwt_key
  end

  def current_user
    @current_user
  end

  def post_params
    params.require(:post).permit(:title, :category, :content).merge(user_id: current_user.id)
  end

  def set_post
    params.permit(:id, :token, post: {})
    puts "set"
    @post = Post.find(params[:id])
  end

  def current_user_is_owner?
    @post.user_id == current_user.id
  end
end

class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy]

  def index
    posts = Post.all.order(created_at: :desc)
    posts_with_username = posts.map do |post|
      {post: post, username: User.find_by(id: post.user_id)&.username}
    end

    render json: posts_with_username
  end

  def create
    token = params[:token]
    begin
      decoded_token = JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      puts decoded_token
      if decoded_token && decoded_token[0] && decoded_token[0]['user_id']
        user_id = decoded_token[0]['user_id']
        puts "User ID: #{user_id}"
      else
        puts 'User ID not found in the decoded token'
      end
      # user_id_string = decoded_token["user_id"]

      # if user_id_string =~ /\A\d+\z/ # Check if the string contains only digits
      #   user_id = user_id_string.to_i
      #   # Further processing with the user_id as an integer
      # else
      #   puts user_id
      user = User.find_by(id: user_id)
      puts user.id
      post = Post.create!(post_params.merge(user_id: user.id))
      if post
        render json: post
      else
        render jsdon: post.errors
      end
    rescue JWT::DecodeError => e
      return { error: e.message }
    end
  end

  def show
    render json: @post
  end

  def destroy
    @post&.destroy
    render json: {message: 'Post deleted'}
  end

  private

  def jwt_key
    Rails.application.credentials.jwt_key
  end

  def post_params
    params.permit(:title, :category, :content)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

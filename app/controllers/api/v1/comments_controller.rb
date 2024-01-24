class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[show]
  before_action :authenticate_user, only: %i[show create update]

  def show
    render json: {
      comment: @comment,
      is_owner: current_user_is_owner?
    }
  end

  def create
    puts comment_params
    comment = Comment.create!(comment_params)
  end

  def update
    update_comment = Comment.find(params[:comment][:id])
    puts update_comment
    update_comment.update(params[:comment].as_json(only: [:content]))
  end

  def destroy
    comment_rating = CommentRating.where(comment_id: params[:comment][:id])
    comment_rating.destroy_all
    comment = Comment.find(params[:comment][:id])
    comment.destroy
    render json: { message: 'Post deleted' }
  end

  private

  def update_params
    params.require(:comment).permit(:content)
  end

  def authenticate_user
    params.permit(:token, :id, comment:{})
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

  def set_comment
    params.permit(:id, :token, comment: {})
    puts "set"
    @comment = Comment.find(params[:id])
  end

  def jwt_key
    Rails.application.credentials.jwt_key
  end

  def current_user
    @current_user
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id).merge(user_id: current_user.id)
  end

end

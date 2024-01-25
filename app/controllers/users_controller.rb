class UsersController < ApplicationController
  # Create a new User
  def create
    check_user = User.find_by(username: params[:user][:username])
    if check_user
      render json: {error: "username was used", statusText: "username used"}, status: :unprocessable_entity
      return
    end
    user = User.new(user_params)

    if user.save
      token = encode_token(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Set parameters required
  def user_params
    params.require(:user).permit(:username, :password)
  end

  # Set jwt key
  def jwt_key
    Rails.application.credentials.jwt_key
  end

  # Encode token
  def encode_token(payload)
    JWT.encode(payload, jwt_key, 'HS256')
  end
end

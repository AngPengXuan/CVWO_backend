class UsersController < ApplicationController
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

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def jwt_key
      Rails.application.credentials.jwt_key
    end

    def encode_token(payload)
      JWT.encode(payload, jwt_key, 'HS256') # Replace 'yourSecretKey' with your secret key
    end
  end

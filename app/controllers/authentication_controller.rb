# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def destroy
    # Log out functionality (optional for JWT)
    # If you have a frontend, clearing the token from client-side is enough
    render json: { message: 'Logged out successfully' }
  end

  def validate
    token = params[:token]

    begin
      decoded_token = JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      # puts decoded_token

      payload = decoded_token.first
      puts payload

      # Check for additional conditions if needed
      # Example: Check for expiration
      # if payload['exp'] < Time.now.to_i
      #   return { error: 'Token has expired' }
      # end

      # Return the decoded payload if everything is valid
      payload
    rescue JWT::DecodeError => e
      return { error: e.message }
    end
  end

  private

  def jwt_key
    Rails.application.credentials.jwt_key
  end

  def encode_token(payload)
    JWT.encode(payload, jwt_key, 'HS256') # Replace 'yourSecretKey' with your secret key
  end
end

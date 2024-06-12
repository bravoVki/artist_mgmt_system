class AuthenticationController < ApplicationController
    skip_before_action :authorize_request, only: :authenticate
  
    def authenticate
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end
  
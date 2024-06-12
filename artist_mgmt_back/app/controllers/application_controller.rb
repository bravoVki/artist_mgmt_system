# class ApplicationController < ActionController::API
#     include AuthorizeRequest
#   end
  
class ApplicationController < ActionController::API
    include Authenticable

    before_action :authorize_request
    
    def not_found
      render json: { error: 'not_found' }
    end
  
    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      decoded = jwt_decode(header)
      if decoded
        @current_user = User.find(decoded[:user_id])
      else
        render json: { errors: 'Invalid token' }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  
    private
  
    def jwt_encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  
    def jwt_decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
  

  
  
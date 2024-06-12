module Authenticable
    def current_user
       return  @current_user ||= User.find_by(id: session[:id])
    end

end

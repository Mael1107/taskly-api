class ApplicationController < ActionController::API
  private
   
  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = JwtService.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded["user_id"])
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end
end

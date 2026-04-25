class Api::V1::AuthController < ApplicationController
  def register
    user = User.new(user_params)

    if user.save
      token = JwtService.encode(user_id: user.id)
      
      render json: {
        token: token,
        user: { id: user.id, name: user.name, email: user.email }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)

      render json: {
        token: token,
        user: { id: user.id, name: user.name, email: user.email }
      }, status: :ok
    else
      render json: { error: "Email or password invalids!" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
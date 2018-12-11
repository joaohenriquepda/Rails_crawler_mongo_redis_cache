# frozen_string_literal: true

# Class AuthController
class AuthController < ApplicationController
  skip_before_action :jwt_auth_validation

  def user_auth
    if params[:email] && params[:password]
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        payload = {
          user_id: user.id,
          token_type: 'client_a2',
          exp: 4.hours.from_now.to_i
        }
        jwt_token = jwt_encode(payload)

        render json: { token: jwt_token }, status: 200
      else
        msg = 'Wrong email or password.'
        render json: { error: msg }, status: :unauthorized
      end
    else
      msg = 'Missing necessary params.'
      render json: { error: msg }, status: :unauthorized
    end
  end
end

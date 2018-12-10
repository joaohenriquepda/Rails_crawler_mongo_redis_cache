class AuthController < ApplicationController
  skip_before_action :jwt_auth_validation

  def user_auth
    puts "DEVERIA ENTRAR AQUI"
    puts Rails.application.secrets.hmac_secret
    puts params[:email]
    puts params[:password]
    if params[:email] && params[:password]

      user = User.find_by(email:params[:email])

      if user && user.authenticate(params[:password])
        payload = {
          user_id: user.id,
          token_type: 'client_a2',
          exp: 4.hours.from_now.to_i,
        }
        jwt_token = jwt_encode(payload)

        render json: { token: jwt_token }, status: 200
      else
        render json: { error: 'Wrong email or password, please make sure if your caps lock has been pressed or if email is correct and try again.' }, status: :unauthorized
      end
    else
      render json: { error: 'Missing necessary params.' }, status: :unauthorized
    end
  end
end

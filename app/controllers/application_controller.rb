# frozen_string_literal: true

# Class ApplicationController
class ApplicationController < ActionController::API
  before_action :jwt_auth_validation

  # Function for validate headers and return token JWT
  def jwt_auth_validation
    if request.headers['Authentication'].present?
      token_decoded = jwt_decode(request.headers['Authentication'])

      if token_decoded.length > 1
        # jwt has been successfully decoded
        pswrc = token_decoded[0]['request_type'] == 'password_recovery'
        if jwt_invalid_payload(token_decoded[0])
          msg = 'Authentication error, invalid payload.'
          render json: { error: msg }, status: :unauthorized

        elsif !jwt_invalid_payload(token_decoded[0]) && pswrc
          # password recovery token verification
          fullpath = '/users/' + token_decoded[0]['user_id'].to_s
          unless request.original_fullpath.index(fullpath).zero?
            msg = 'Permission error, action unauthorized.'
            render json: { error: msg }, status: :unauthorized
          end
        end
      elsif token_decoded.length == 1
        # jwt hasn't been decoded
        if !token_decoded[0][:expired].nil? && token_decoded[0][:expired]
          msg = 'Authentication error, token has been expired.'
          render json: { error: msg }, status: :unauthorized
        end
        msg = 'Authentication error, token is wrong on header Authentication'
        render json: { error: msg }, status: :unauthorized
      end

      # renew token
      if token_decoded.length > 1
        renewed_payload = token_decoded.first

        if renewed_payload['exp'].present?
          time_start = Time.at(renewed_payload['exp']) - 1.hours
          time_end = Time.at(renewed_payload['exp'])
          time_now = Time.now.to_i

          if time_now >= time_start.to_i && time_now <= time_end.to_i
            renewed_payload['exp'] = 4.hours.from_now.to_i
            response.headers['JWT-Token-Renewed'] = jwt_encode(renewed_payload)
          end
        end
      end
    else
      msg = 'Authentication error, token is missing on header Authentication'
      render json: { error: msg }, status: :unauthorized
    end
  end

  private

  def jwt_decode(jwt_hash)
    algo = { algorithm: 'HS256' }
    JWT.decode jwt_hash, Rails.application.secrets.hmac_secret, true, algo
  rescue JWT::ExpiredSignature
    [{ expired: true }]
  rescue StandardError
    [{ invalid: true }]
  end

  def jwt_encode(payload = {})
    JWT.encode payload, Rails.application.secrets.hmac_secret, 'HS256'
  end

  def jwt_invalid_payload(payload)
    !payload['token_type'].present? || payload['token_type'].present? &&
      payload['token_type'] != 'client_a2'
  end
end

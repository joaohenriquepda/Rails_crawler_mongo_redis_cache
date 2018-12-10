class ApplicationController < ActionController::API
  before_action :jwt_auth_validation

  # Function for validate headers and return token JWT
   def jwt_auth_validation
     puts "AQUI"
    if request.headers['Authentication'].present?
      token_decoded = jwt_decode(request.headers['Authentication'])

      if token_decoded.length > 1
        # jwt has been successfully decoded
        if jwt_invalid_payload(token_decoded[0])
          render json: { error: 'Authentication error, invalid payload.' }, status: :unauthorized
          return;
        elsif !jwt_invalid_payload(token_decoded[0]) && token_decoded[0]['request_type'] == 'password_recovery'
          # password recovery token verification
          unless request.original_fullpath.index('/users/'+token_decoded[0]['user_id'].to_s) == 0
            render json: { error: 'Permission error, action unauthorized.' }, status: :unauthorized
            return;
          end
        end
      elsif token_decoded.length == 1
        # jwt hasn't been decoded
        if !token_decoded[0][:expired].nil? && token_decoded[0][:expired]
          render json: { error: 'Authentication error, token has been expired.' }, status: :unauthorized
          return;
        else
          render json: { error: 'Authentication error, token is wrong on header Authentication' }, status: :unauthorized
          return;
        end
      end

      # renew token
      if token_decoded.length>1
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
      render json: { error: 'Authentication error, token is missing on header Authentication' }, status: :unauthorized
      return;
    end
  end

  private
    def jwt_decode(jwt_hash)
      begin
        JWT.decode jwt_hash, Rails.application.secrets.hmac_secret, true, { :algorithm => 'HS256' }
      rescue JWT::ExpiredSignature
        [{ expired: true }]
      rescue
        [{ invalid: true }]
      end
    end

    def jwt_encode(payload = {})
      JWT.encode payload, Rails.application.secrets.hmac_secret, 'HS256'
    end

    def jwt_invalid_payload(payload)
      !payload['token_type'].present? || payload['token_type'].present? && payload['token_type'] != 'client_a2'
    end
end

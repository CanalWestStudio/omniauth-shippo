require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class TradeGecko < OmniAuth::Strategies::OAuth2
      option :name, :tradegecko

      option :client_options, {
        site:           "https://api.tradegecko.com",
        authorize_path: "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          first_name: raw_info["first_name"],
          last_name:  raw_info["last_name"],
          email:      raw_info["email"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/users/current').parsed["user"]
      end
    end
  end
end

OmniAuth.config.add_camelization 'tradegecko', 'TradeGecko'
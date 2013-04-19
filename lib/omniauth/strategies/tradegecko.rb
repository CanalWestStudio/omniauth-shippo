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
          account_id: raw_info["account_id"],
          email:      raw_info["email"],
          first_name: raw_info["first_name"],
          last_name:  raw_info["last_name"],
          full_name:  full_name
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/users/current').parsed["user"]
      end

      def full_name
        [raw_info["first_name"], raw_info["last_name"]].compact.join(" ")
      end
    end
  end
end

OmniAuth.config.add_camelization 'tradegecko', 'TradeGecko'
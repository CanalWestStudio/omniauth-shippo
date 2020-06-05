# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shippo < OmniAuth::Strategies::OAuth2
      option :name, :shippo

      option :client_options, {
        site: 'https://goshippo.com',
        authorize_path: '/oauth/authorize'
      }

      uid { Digest::SHA256.base64digest(raw_info['access_token']) }

      info do
        {
          scope: raw_info['scope'],
          token_type: raw_info['token_type']
        }
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

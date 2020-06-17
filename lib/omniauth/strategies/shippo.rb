# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shippo < OmniAuth::Strategies::OAuth2
      option :name, :shippo

      option :client_options, {
        site: 'https://goshippo.com',
        token_url: '/oauth/access_token'
      }

      uid { Digest::SHA256.base64digest(raw_info['access_token']) }

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

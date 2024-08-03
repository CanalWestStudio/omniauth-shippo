# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shippo < OmniAuth::Strategies::OAuth2
      module Defaults
        ACCOUNTS_ENDPOINT = 'https://api.goshippo.com/shippo-accounts'.freeze
      end

      option :name, :shippo

      option :client_options, {
        site: 'https://goshippo.com',
        token_url: '/oauth/access_token'
      }

      uid { results['object_id'] }

      info do
        results
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def raw_info
        @raw_info ||= access_token.get(Defaults::ACCOUNTS_ENDPOINT).parsed
      end

      private

      def results
        raw_info['results'].first
      end
    end
  end
end

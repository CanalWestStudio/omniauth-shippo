# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shippo < OmniAuth::Strategies::OAuth2
      module Defaults
        ACCOUNTS_ENDPOINT = 'https://api.goshippo.com/shippo-accounts'.freeze
      end

      option :name, :shippo

      # Allow customization of client options and accounts endpoint
      option :client_options, {
        site: 'https://goshippo.com',
        token_url: '/oauth/access_token',
        request_timeout: 10 # Add a timeout for API requests
      }
      option :accounts_endpoint, Defaults::ACCOUNTS_ENDPOINT
      option :uid_field, 'object_id' # Allow customization of the UID field

      uid { results[options[:uid_field]] }

      info do
        results # Return the entire results hash dynamically
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def raw_info
        @raw_info ||= fetch_raw_info
      end

      private

      def fetch_raw_info
        response = access_token.get(options[:accounts_endpoint])
        raise OmniAuth::Error, "Failed to fetch user info: #{response.status}" unless response.status == 200

        parsed_response = response.parsed
        validate_response!(parsed_response)
        parsed_response
      rescue Faraday::Error => e
        Rails.logger.error("Shippo API request failed: #{e.message}") # Add logging
        raise OmniAuth::Error, "API request failed: #{e.message}"
      end

      def validate_response!(response)
        unless response.is_a?(Hash) && response.key?('results') && response['results'].is_a?(Array)
          raise OmniAuth::Error, "Invalid API response structure"
        end
      end

      def results
        @results ||= raw_info['results'].first || {}
      end
    end
  end
end
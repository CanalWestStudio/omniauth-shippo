# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shippo < OmniAuth::Strategies::OAuth2
      ACCOUNTS_ENDPOINT = 'https://api.goshippo.com/shippo-accounts'
      MAX_RETRIES = 2
      BACKOFF_BASE = 0.5 # seconds

      option :name, :shippo
      option :client_options, {
        site: 'https://goshippo.com',
        token_url: '/oauth/access_token',
        request_timeout: 15
      }

      uid { results['shippo_id'] }

      info do
        results
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def authorize_params
        super.tap do |params|
          if options.authorize_params
            log(:info, "Shippo authorize_params: #{options.authorize_params.to_h.inspect}")
            params.merge!(options.authorize_params) if options.authorize_params
          end
        end
      end

      def callback_url
        full_host + callback_path
      end

      def raw_info
        @raw_info ||= fetch_raw_info
      end

      private

      def fetch_raw_info
        retries = 0
        begin
          response = access_token.get(ACCOUNTS_ENDPOINT)
          validate_response!(response)
          response.parsed
        rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
          retries += 1
          raise OmniAuth::Error, "Failed to connect to Shippo API: #{e.message}" if retries > MAX_RETRIES

          log(:warn, "Shippo API request failed (#{e.class}), retry #{retries}/#{MAX_RETRIES}")
          sleep(BACKOFF_BASE * (2**(retries - 1)))
          retry
        rescue Faraday::Error => e
          raise OmniAuth::Error, "Shippo API error: #{e.message}"
        end
      end

      def validate_response!(response)
        raise OmniAuth::Error, "Shippo API returned HTTP #{response.status}" unless response.status == 200

        parsed = response.parsed
        unless parsed.is_a?(Hash) && parsed['results'].is_a?(Array)
          raise OmniAuth::Error, "Invalid API response structure from Shippo"
        end
      end

      def results
        @results ||= begin
          source = raw_info['results']&.first || {}
          result = source.dup

          if result.key?('object_id')
            result['shippo_id'] = result.delete('object_id')
          end

          result
        end
      end

      def log(level, message)
        OmniAuth.logger&.send(level, "(shippo) #{message}")
      end
    end
  end
end

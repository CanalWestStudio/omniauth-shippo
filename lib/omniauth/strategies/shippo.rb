require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shippo < OmniAuth::Strategies::OAuth2
      module Defaults
        ACCOUNTS_ENDPOINT = 'https://api.goshippo.com/shippo-accounts'.freeze
        REQUEST_TIMEOUT = 15 # seconds
        RETRY_COUNT = 2
      end
      
      option :name, :shippo
      option :client_options, {
        site: 'https://goshippo.com',
        token_url: '/oauth/access_token',
        request_timeout: Defaults::REQUEST_TIMEOUT
      }
      
      # Using the renamed field for the UID
      uid { results['shippo_id'] }
      
      info do
        results
      end
      
      extra do
        {
          'raw_info' => raw_info
        }
      end
      
      def callback_url
        full_host + script_name + callback_path
      end
      
      def raw_info
        @raw_info ||= fetch_raw_info
      end
      
      private
      
      def fetch_raw_info
        retries = 0
        begin
          log(:info, "Fetching user data from Shippo API")
          response = access_token.get(Defaults::ACCOUNTS_ENDPOINT)
          validate_response(response)
          response.parsed
        rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
          retries += 1
          if retries <= Defaults::RETRY_COUNT
            log(:warn, "Shippo API request failed (#{e.class.name}): #{e.message}. Retrying (#{retries}/#{Defaults::RETRY_COUNT})...")
            sleep(0.5 * retries) # Exponential backoff
            retry
          else
            log(:error, "Shippo API request failed after #{Defaults::RETRY_COUNT} retries: #{e.message}")
            raise OmniAuth::Error, "Failed to connect to Shippo API: #{e.message}"
          end
        rescue Faraday::Error => e
          log(:error, "Shippo API request error: #{e.class.name} - #{e.message}")
          raise OmniAuth::Error, "Shippo API error: #{e.message}"
        end
      end
      
      def validate_response(response)
        unless response.status == 200
          log(:error, "Shippo API returned non-200 status code: #{response.status}")
          raise OmniAuth::Error, "Failed to fetch user info: HTTP #{response.status}"
        end
        
        parsed = response.parsed
        unless parsed.is_a?(Hash) && parsed.key?('results') && parsed['results'].is_a?(Array)
          log(:error, "Invalid Shippo API response structure: #{parsed.inspect[0..100]}...")
          raise OmniAuth::Error, "Invalid API response structure from Shippo"
        end
        
        if parsed['results'].empty?
          log(:warn, "Shippo API returned empty results array")
        end
      end
      
      def results
        @results ||= begin
          result = raw_info['results'].first || {}
          
          # Rename the problematic 'object_id' key to 'shippo_id'
          if result.key?('object_id')
            result['shippo_id'] = result.delete('object_id')
            log(:debug, "Renamed 'object_id' to 'shippo_id' to avoid Ruby method conflict")
          end
          
          # Add helpful metadata
          result['provider'] = name.to_s
          result['connected_at'] = Time.now.utc.iso8601
          
          result
        end
      end
      
      def log(level, message)
        OmniAuth.logger.send(level, "(shippo) #{message}")
      rescue => e
        # Fail silently if logging itself fails
      end
    end
  end
end
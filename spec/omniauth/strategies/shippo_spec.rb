# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OmniAuth::Strategies::Shippo do
  let(:strategy) { OmniAuth::Strategies::Shippo.new(app, 'client_id', 'client_secret') }
  let(:app) { ->(env) { [200, {}, ['OK']] } }

  let(:shippo_account) do
    {
      'object_id' => 'abc123',
      'email' => 'user@example.com',
      'first_name' => 'Jane',
      'last_name' => 'Doe'
    }
  end

  let(:valid_api_response) do
    { 'results' => [shippo_account] }
  end

  let(:access_token) { instance_double(OAuth2::AccessToken) }

  before do
    allow(strategy).to receive(:access_token).and_return(access_token)
  end

  describe 'options' do
    it 'has the correct name' do
      expect(strategy.options.name).to eq :shippo
    end

    it 'has the correct client options' do
      client_options = strategy.options.client_options
      expect(client_options.site).to eq 'https://goshippo.com'
      expect(client_options.token_url).to eq '/oauth/access_token'
    end
  end

  describe '#callback_url' do
    it 'is a combination of host and callback path without duplicating script_name' do
      allow(strategy).to receive(:full_host).and_return('https://example.com')
      allow(strategy).to receive(:script_name).and_return('/sub_uri')

      expect(strategy.callback_url).to eq('https://example.com/sub_uri/auth/shippo/callback')
    end
  end

  describe '#raw_info' do
    it 'fetches and returns the parsed API response' do
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get).and_return(response)

      expect(strategy.raw_info).to eq(valid_api_response)
    end

    it 'memoizes the result' do
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get).and_return(response)

      strategy.raw_info
      strategy.raw_info

      expect(access_token).to have_received(:get).once
    end
  end

  describe '#uid' do
    it 'returns the shippo_id (renamed from object_id)' do
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get).and_return(response)

      expect(strategy.uid).to eq('abc123')
    end
  end

  describe '#info' do
    it 'renames object_id to shippo_id' do
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get).and_return(response)

      info = strategy.info
      expect(info['shippo_id']).to eq('abc123')
      expect(info).not_to have_key('object_id')
    end

    it 'preserves other fields from the API response' do
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get).and_return(response)

      info = strategy.info
      expect(info['email']).to eq('user@example.com')
      expect(info['first_name']).to eq('Jane')
      expect(info['last_name']).to eq('Doe')
    end

    it 'handles responses without object_id' do
      account = { 'email' => 'user@example.com' }
      response = instance_double(OAuth2::Response, status: 200, parsed: { 'results' => [account] })
      allow(access_token).to receive(:get).and_return(response)

      expect(strategy.info).not_to have_key('shippo_id')
      expect(strategy.info).not_to have_key('object_id')
    end
  end

  describe '#extra' do
    it 'includes raw_info' do
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get).and_return(response)

      expect(strategy.extra['raw_info']).to eq(valid_api_response)
    end
  end

  describe 'response validation' do
    it 'raises on non-200 status' do
      response = instance_double(OAuth2::Response, status: 401, parsed: {})
      allow(access_token).to receive(:get).and_return(response)

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error, /HTTP 401/)
    end

    it 'raises on invalid response structure' do
      response = instance_double(OAuth2::Response, status: 200, parsed: { 'unexpected' => 'data' })
      allow(access_token).to receive(:get).and_return(response)

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error, /Invalid API response/)
    end

    it 'raises when parsed response is not a hash' do
      response = instance_double(OAuth2::Response, status: 200, parsed: 'not a hash')
      allow(access_token).to receive(:get).and_return(response)

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error, /Invalid API response/)
    end

    it 'raises on empty results array' do
      response = instance_double(OAuth2::Response, status: 200, parsed: { 'results' => [] })
      allow(access_token).to receive(:get).and_return(response)

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error, /no account results/)
    end
  end

  describe 'retry behavior' do
    before do
      allow(strategy).to receive(:sleep)
    end

    it 'retries on Faraday::TimeoutError and succeeds' do
      call_count = 0
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get) do
        call_count += 1
        raise Faraday::TimeoutError if call_count <= 2
        response
      end

      expect(strategy.raw_info).to eq(valid_api_response)
      expect(call_count).to eq(3)
    end

    it 'retries on Faraday::ConnectionFailed and succeeds' do
      call_count = 0
      response = instance_double(OAuth2::Response, status: 200, parsed: valid_api_response)
      allow(access_token).to receive(:get) do
        call_count += 1
        raise Faraday::ConnectionFailed, 'connection refused' if call_count <= 1
        response
      end

      expect(strategy.raw_info).to eq(valid_api_response)
      expect(call_count).to eq(2)
    end

    it 'raises after exhausting retries' do
      allow(access_token).to receive(:get).and_raise(Faraday::TimeoutError)

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error, /Failed to connect/)
    end

    it 'backs off between retries' do
      allow(access_token).to receive(:get).and_raise(Faraday::TimeoutError)

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error)

      expect(strategy).to have_received(:sleep).twice
    end

    it 'wraps non-retryable Faraday errors in OmniAuth::Error' do
      allow(access_token).to receive(:get).and_raise(Faraday::Error, 'something broke')

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error, /Shippo API error/)
    end

    it 'does not retry non-retryable Faraday errors' do
      allow(access_token).to receive(:get).and_raise(Faraday::Error, 'something broke')

      expect { strategy.raw_info }.to raise_error(OmniAuth::Error)
      expect(access_token).to have_received(:get).once
    end
  end
end

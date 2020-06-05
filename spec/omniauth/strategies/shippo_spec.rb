# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OmniAuth::Strategies::Shippo do
  let(:strategy) do
    OmniAuth::Strategies::Shippo.new({})
  end

  it :options do
    expect(strategy.options.name).to eql :shippo
  end

  it :client_options do
    client_options = strategy.options.client_options
    expect(client_options.site).to eql 'https://goshippo.com'
    expect(client_options.authorize_path).to eql '/oauth/authorize'
  end

  context :raw_info do
    before do
      allow(strategy).to receive(:raw_info) do
        {
          'scope' => '*',
          'token_type' => 'bearer',
          'access_token' => 'oauth.612BUDkTaTuJP3ll5-VkebURXUIJ5Zefxwda1tpd.U_akmGaXVQl80CWPXSbueSG7NX7sNe_HvLJLN1d1pn0='
        }
      end
    end

    it 'exposes user info' do
      expect(strategy.uid).to eql 'iSKWRBS3V/688fbDW2tlRdrDAJGmTEpneAfzTi1fh5A='
      expect(strategy.info).to eql({
        scope: '*',
        token_type: 'bearer'
      })
    end
  end

  describe '#callback_url' do
    it 'is a combination of host, script name, and callback path' do
      allow(strategy).to receive(:full_host).and_return('https://example.com')
      allow(strategy).to receive(:script_name).and_return('/sub_uri')

      expect(strategy.callback_url).to eq('https://example.com/sub_uri/auth/shippo/callback')
    end
  end
end

require 'spec_helper'

describe OmniAuth::Strategies::TradeGecko do
  let(:strategy) do
    OmniAuth::Strategies::TradeGecko.new({})
  end

  it :options do
    expect(strategy.options.name).to eql :tradegecko
  end

  it :client_options do
    client_options = strategy.options.client_options
    expect(client_options.site).to eql "https://api.tradegecko.com"
    expect(client_options.authorize_path).to eql "/oauth/authorize"
  end

  context :raw_info do
    before do
      allow(strategy).to receive(:raw_info) do
        {
          "first_name" => "Invader",
          "account_id" => 1,
          "last_name"  => "Zim",
          "email"      => "invaderzim@example.com",
          "login_id"   => 2
        }
      end
    end

    it "exposes user info" do
      expect(strategy.info).to eql({
        first_name: "Invader",
        last_name:  "Zim",
        email:      "invaderzim@example.com",
        name:       "Invader Zim",
        account_id: 1,
        login_id:   2
      })
    end
  end

  describe '#callback_url' do
    it 'is a combination of host, script name, and callback path' do
      allow(strategy).to receive(:full_host).and_return('https://example.com')
      allow(strategy).to receive(:script_name).and_return('/sub_uri')

      expect(strategy.callback_url).to eq('https://example.com/sub_uri/auth/tradegecko/callback')
    end
  end
end

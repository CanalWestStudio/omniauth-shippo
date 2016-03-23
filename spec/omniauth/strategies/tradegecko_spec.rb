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
          "email"      => "invaderzim@example.com"
        }
      end
    end

    it "exposes user info" do
      expect(strategy.info).to eql({
        first_name: "Invader",
        last_name:  "Zim",
        email:      "invaderzim@example.com",
        name:       "Invader Zim"
      })
    end
  end
end
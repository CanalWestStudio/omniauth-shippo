require 'spec_helper'

describe OmniAuth::Strategies::TradeGecko do
  let(:strategy) do
    OmniAuth::Strategies::TradeGecko.new({})
  end
  context :options do
    subject { strategy.options }
    its(:name) { should eql :tradegecko }
  end

  context :client_options do
    subject { strategy.options.client_options }
    its(:site)            { should eql "https://api.tradegecko.com" }
    its(:authorize_path)  { should eql "/oauth/authorize" }
  end

  context :raw_info do
    before do
      strategy.stub(:raw_info) do
        {
          "first_name" => "Invader",
          "account_id" => 1,
          "last_name"  => "Zim",
          "email"      => "invaderzim@example.com"
        }
      end
    end
    it "exposes user info" do
      strategy.info.should eql({
        account_id: 1,
        first_name: "Invader",
        last_name:  "Zim",
        email:      "invaderzim@example.com",
        full_name:  "Invader Zim"
      })
    end
  end
end
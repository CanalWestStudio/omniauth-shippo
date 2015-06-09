# Omniauth::TradeGecko [![Build Status](https://travis-ci.org/tradegecko/omniauth-tradegecko.png)](https://travis-ci.org/tradegecko/omniauth-tradegecko)

This is the TradeGecko strategy for authenticating to TradeGecko via OmniAuth. 
For more information about the TradeGecko API check out [http://developer.tradegecko.com](http://developer.tradegecko.com/)

## Usage
In `config/initializers/tradegecko.rb`

```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :tradegecko, ENV['TRADEGECKO_ID'], ENV['TRADEGECKO_SECRET']
  end
```

## Questions
Contact me at [bradley@tradegecko.com](mailto:bradley@tradegecko.com) or [@bradleypriest](http://twitter.com/bradleypriest)

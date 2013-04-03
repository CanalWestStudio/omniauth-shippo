# Omniauth::TradeGecko

This is the TradeGecko strategy for authenticating to TradeGecko via OmniAuth. 
For more information about the TradeGecko API check out [http://tradegecko.com/apps/api](http://tradegecko.com/apps/api)

## Usage
In `config/initializers/tradegecko.rb`

```ruby
  use OmniAuth::Builder do
    provider :tradegecko, ENV['TRADEGECKO_ID'], ENV['TRADEGECKO_SECRET']
  end
```

## Questions
Contact me at [bradleypriest@gmail.com](mailto:bradleypriest@gmail.com) or [@bradleypriest](http://twitter.com/bradleypriest)
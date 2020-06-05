# Omniauth::Shippo [![Build Status](https://travis-ci.org/tradegecko/omniauth-shippo.png)](https://travis-ci.org/tradegecko/omniauth-shippo)

This is the Shippo strategy for authenticating to Shippo via OmniAuth. 

## Usage
In `config/initializers/shippo.rb`

```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :shippo, ENV['SHIPPO_ID'], ENV['SHIPPO_SECRET']
  end
```

## Questions
Contact me at [bradley@tradegecko.com](mailto:bradley@tradegecko.com) or [@bradleypriest](https://twitter.com/bradleypriest)

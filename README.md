# OmniAuth Shippo

[![CI](https://github.com/CanalWestStudio/omniauth-shippo/actions/workflows/ci.yml/badge.svg)](https://github.com/CanalWestStudio/omniauth-shippo/actions/workflows/ci.yml)

OmniAuth strategy for authenticating with [Shippo](https://goshippo.com) via OAuth2.

## Installation

Add to your Gemfile:

```ruby
gem 'omniauth-shippo'
```

## Usage

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shippo, ENV['SHIPPO_CLIENT_ID'], ENV['SHIPPO_CLIENT_SECRET']
end
```

### With custom authorize params

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shippo, ENV['SHIPPO_CLIENT_ID'], ENV['SHIPPO_CLIENT_SECRET'],
    authorize_params: { utm_source: 'your_app' }
end
```

## Auth Hash

Here's an example of the auth hash available in `request.env['omniauth.auth']`:

```ruby
{
  "provider" => "shippo",
  "uid" => "abc123...",
  "info" => {
    "shippo_id" => "abc123...",
    "email" => "user@example.com",
    "first_name" => "Jane",
    "last_name" => "Doe"
    # ... other fields from Shippo accounts API
  },
  "credentials" => {
    "token" => "access_token_value",
    "refresh_token" => "refresh_token_value",
    "expires_at" => 1234567890,
    "expires" => true
  },
  "extra" => {
    "raw_info" => {
      "results" => [
        {
          "object_id" => "abc123...",
          "email" => "user@example.com",
          # ... full Shippo API response
        }
      ]
    }
  }
}
```

Note: `object_id` is renamed to `shippo_id` in `info` to avoid conflicting with Ruby's `Object#object_id` method. The original `object_id` key is preserved in `extra.raw_info`.

## Development

```sh
bundle install
bundle exec rspec
```

To run with coverage:

```sh
COVERAGE=1 bundle exec rspec
```

## License

MIT. See [LICENSE](LICENSE).

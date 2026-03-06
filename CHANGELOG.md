# Changelog

## 2.0.0 (Unreleased)

### Breaking Changes

- Pin `omniauth ~> 2.0` and `omniauth-oauth2 ~> 1.7` — drops support for omniauth 1.x
- Fix `callback_url` duplicating `script_name` — consumers with sub-URI deployments
  must re-register their OAuth redirect URI with Shippo
- Remove `provider` and `connected_at` from the `info` hash — `provider` is already
  available via `auth_hash['provider']`, and `connected_at` was non-deterministic
- Raise `OmniAuth::Error` on empty results instead of silently returning nil UID

### Fixed

- Fix mutable state: `results` no longer mutates `raw_info` in place
- Fix log filtering: no longer logs sensitive param values or API response bodies
- Fix backoff: retry delay is now truly exponential (0.5s, 1.0s, 2.0s)
- Remove redundant `authorize_params` override that double-merged params
- Use safe navigation for logger to prevent nil logger from crashing OAuth flow
- Remove overly broad rescue in log method that silently swallowed all errors

### Added

- GitHub Actions CI with Ruby 3.1–3.4 matrix
- Comprehensive test suite (3 → 20 specs)
- `frozen_string_literal` pragma
- Gemspec metadata (source_code_uri, changelog_uri, bug_tracker_uri)
- Required Ruby version >= 3.1
- MFA required for gem pushes

### Changed

- Flatten `Defaults` module into class-level constants
- Rename `validate_response` → `validate_response!` (raises convention)
- Replace shell-executed `git ls-files` with `Dir.glob` in gemspec
- Gate simplecov behind `ENV['COVERAGE']`
- Update homepage to CanalWestStudio org

## 1.0.0

- Initial release — repurposed from omniauth-tradegecko
- Added retry logic with backoff for Shippo API requests
- Added response validation
- Renamed `object_id` to `shippo_id` to avoid Ruby method conflict
- Fetch account info from Shippo accounts endpoint

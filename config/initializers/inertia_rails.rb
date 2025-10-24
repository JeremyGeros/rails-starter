# frozen_string_literal: true

InertiaRails.configure do |config|
  config.version = ViteRuby.digest
  config.encrypt_history = false
  config.always_include_errors_hash = true
end

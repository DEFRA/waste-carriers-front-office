# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  config.log_formatter = Logger::Formatter.new

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  config.i18n.raise_on_missing_translations = true

  # The rails web console allows you to execute arbitrary code on the server. By
  # default, only requests coming from IPv4 and IPv6 localhosts are allowed.
  # When running in a vagrant box it'll use a different IP e.g. 10.0.2.2 so
  # to stop getting `Cannot render console from 10.0.2.2!` in the logs you need
  # to add its IP to this white list. The SSH_CLIENT holds this value but it
  # contains some other stuff as well e.g. 10.0.2.2 59811 22. Hence we use fetch
  # so we can assign the default (for none vagrant boxes) else grab the env var
  # but just the first part of it.
  # https://github.com/rails/web-console#configuration
  # https://stackoverflow.com/a/29417509
  config.web_console.allowed_ips = ENV.fetch("SSH_CLIENT", "127.0.0.1").split.first
end

EolTranslationToolRails::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  
  From_Mail = "user@mail.com"   
  DEFAULT_HIERARCHY_ID = 3
  ITEMS_PER_PAGE = 1
  VETTED_UNKNOWN = 1
  VETTED_TRUSTED = 4
  VETTED_UNTRUSTED =2 
  EOL_SITE_URL = 'http://www.eol.org'
  VISIBILITY_INVISIBLE =  '0'
  LANGUAGE_EN = '1'
  DATA_TYPES_TEXT = '3'
  TOC_INCLUDED_PARENT_IDS = '1, 3, 4, 5, 6, 8, 256, 303, 315, 326, 346'
  DATA_TYPES_MEDIA = '2, 4, 7, 8'
  MASTER = 'eol_data'
  SLAVE = 'aeol'
end

require 'spec_helper'
require 'capybara/rspec'
require 'selenium-webdriver'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# ------ Capybara 基本設定（RSpec.configure の外）------
Capybara.default_max_wait_time = 3
Capybara.server = :puma, { Silent: true }
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless
# ----------------------------------------------------

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :system
  config.after(:each, type: :system) { Warden.test_reset! }

  # support 配下を読む
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  # System Spec では常にビルトインの headless Chrome を使う
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
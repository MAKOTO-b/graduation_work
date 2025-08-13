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

# ===== Capybara 基本設定 =====
Capybara.default_max_wait_time = 3
Capybara.server = :puma, { Silent: true }

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
# =============================

RSpec.configure do |config|
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :system
  config.after(:each, type: :system) { Warden.test_reset! }

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  # 全 system spec を headless_chrome で統一
  config.before(:each, type: :system) do
    driven_by :headless_chrome
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # CIもローカルもこれでOK（Chromeはheadless）
    driven_by :selenium, using: :chrome, options: { headless: true }
  end
end

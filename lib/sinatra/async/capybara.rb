require 'sinatra/async/test'
require 'capybara'

# This is a capybara driver for async_sinatra.
# Use it like this:
#
#   require 'capybara'
#   require 'sinatra/async/capybara'
#
#   Capybara.default_driver = :as_rack_test
class Capybara::Driver::AsRackTest < Capybara::Driver::RackTest
  include Sinatra::Async::Test::Methods
  include Test::Unit::Assertions

  def get(*args, &block)
    super
    assert_async
    async_continue
  end

  def post(*args, &block)
    super
    assert_async
    async_continue
  end

  def put(*args, &block)
    super
    assert_async
    async_continue
  end

  def delete(*args, &block)
    super
    assert_async
    async_continue
  end

  def build_rack_mock_session # :nodoc:
    Sinatra::Async::Test::AsyncSession.new(app, Capybara.default_host || "www.example.com")
  end
end

require 'rubygems'
require 'sinatra'
require 'capybara'
require 'capybara/dsl'
require 'test/unit'
require 'sinatra/async/capybara'


class CapybaraDriverTest < Test::Unit::TestCase
  include Capybara
  include Sinatra::Async::Test::Methods
  Capybara.default_driver = :as_rack_test

  class MyApp < Sinatra::Base
    set :environment, :test
    register Sinatra::Async

    aget '/' do
      body <<-HTML
        <p><em>Capybara</em> Test</p>
        <a href="/click">Link Text</a>
      HTML
    end

    apost '/' do
      body params[:email]
    end

    aget '/click' do
      body <<-HTML
        Clicked the link
        <form action="/" method="post">
          <label for="email">E-Mail</label>
          <input id="email" type="text" name="email" />
          <input type="submit" name="submit" value="Submit!" />
        </form>
      HTML
    end
  end

  def setup
    Capybara.app = MyApp.new
  end

  def test_visit
    visit '/'
    assert current_path == '/'
    assert page.has_xpath?('//p/em')
    assert page.has_content?('Capybara Test')
  end

  def test_click_link
    visit '/'
    click_link('Link Text')
    assert current_path == '/click'
    assert page.has_content?('Clicked the link')
  end

  def test_form_submit
    visit '/click'
    fill_in 'E-Mail', :with => 'test@example.com'
    click_button 'Submit!'
    assert current_path == '/'
    assert page.has_content?('test@example.com')
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'..','..','lib'))

require'rspec/expectations'
require'page-object'
require 'BrowserStack/browserstack.rb'
require'selenium/webdriver'

World(PageObject::PageFactory)

#Installing Cucumber hooks
begin
  if ENV['SELENIUM_PLATFORM'] and !$0.include? 'app_checker.rb'
    Before('@selenium') do
      @browser = ::BrowserStackCucumber.before_hook_impl
    end

    Around('@selenium') do |scenario, block|
      ::BrowserStackCucumber.around_hook_impl(scenario, block)
    end

    at_exit do
      ::BrowserStackCucumber.at_exit_impl()
    end
  end

rescue NoMethodError=>e
  puts e
end


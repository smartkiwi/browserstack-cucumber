# BrowserStackCucumber

A Ruby helper for running tests in BrowserStack Automate browser testing cloud service.

## Installation

Add this line to your application's Gemfile:

    gem 'browserstack-cucumber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install browserstack-cucumber

## Usage

browserstack-cucumber designed to get configuration from environment variables set by Jenkins.

###Code changes:
See features/support/env.rb on how to add BrowserStack support to your cucumber tests:

```ruby
require'rspec/expectations'
require'page-object'
require'browserstack'
require'selenium/webdriver'

World(PageObject::PageFactory)

#Installing Cucumber hooks
Before('@selenium') do
  @browser = ::BrowserStackCucumber.before_hook_impl
end

Around('@selenium') do |scenario, block|
  ::BrowserStackCucumber.around_hook_impl(scenario, block)
end

at_exit do
  ::BrowserStackCucumber.at_exit_impl()
end
```


###Running tests:

You'll need to set the following environment variables (the following values are used http://saucelabs.com/rest/v1/info/browsers/webdriver)
 * SELENIUM_PLATFORM (os)
 * SELENIUM_BROWSER (api_name)
 * SELENIUM_VERSION (short_version)
 * BROWSER_STACK_USER_NAME
 * BROWSER_STACK_API_KEY

To run cucumber tests suite:

    $ cucumber SELENIUM_PLATFORM="Windows 2008" SELENIUM_BROWSER="firefox" SELENIUM_VERSION="24" BROWSER_STACK_API_KEY="<your browserstack api key>" BROWSER_STACK_USER_NAME="<browserstack username>"

##Using BrowserStackCucumber Jenkins Formatter

This gem includes BrowserStackCucumber::JenkinsFormatter. It registers it with shorter name 'browserstack_jenkins' in Cucumber cli.
Using this formatter allows to include URL to BrowserStack session url with every failed scenario error output.

    $ cucumber ... -f browserstack_jenkins --out <report dir>

## Testing the Gem:

set the following env variables
run tests with

    $ bundle exec cucumber SELENIUM_PLATFORM="Windows 2008" SELENIUM_BROWSER="firefox" SELENIUM_VERSION="24" BROWSER_STACK_API_KEY="<your browserstack api key>" BROWSER_STACK_USER_NAME="<browserstack username>"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

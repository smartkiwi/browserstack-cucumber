require 'rubygems'
require 'rest-client'
require 'json'
require 'BrowserStack/wait_until'

module BrowserStackCucumber

  class Config
    attr_reader :browser

    @test_url = 'https://account.jwplayer.com/sign-in'
    @test_substring = 'sign in'
    @browser = nil

    def test_url=(url)
      @test_url = url
    end

    def self.name_from_scenario(scenario)
      # Special behavior to handle Scenario Outlines
      if scenario.instance_of? ::Cucumber::Ast::OutlineTable::ExampleRow
        table = scenario.instance_variable_get(:@table)
        outline = table.instance_variable_get(:@scenario_outline)
        return "#{outline.feature.file} - #{outline.title} - #{table.headers} -> #{scenario.name}"
      end
      scenario, feature = _scenario_and_feature_name(scenario)
      return "#{feature} - #{scenario}"
    end

    def self._scenario_and_feature_name(scenario)
      scenario_name = scenario.name.split("\n").first
      feature_name = scenario.feature.short_name
      return scenario_name, feature_name
    end

    def self.selenium_username
      ENV['BROWSER_STACK_USER_NAME']
    end

    def self.selenium_apikey
      ENV['BROWSER_STACK_API_KEY']
    end

    def self.selenium_os
      #TODO: Windows 8 doesn't match BS
      #'Windows XP' => Windows
      ENV['SELENIUM_PLATFORM'].split(' ')[0]
    end

    def self.selenium_os_version
      #'Windows XP' => XP
      r = ENV['SELENIUM_PLATFORM'].split(' ')[1]
      return 'XP' if (r=='2003')
      return '7' if (r=='2008')
      return '8' if (r=='2012')
      r
    end

    def self.selenium_browser
      #firefox
      ENV['SELENIUM_BROWSER']
    end

    def self.selenium_browser_version
      #21
      ENV['SELENIUM_VERSION']
    end


    def self.capabilities

      capabilities = ::Selenium::WebDriver::Remote::Capabilities.new
      capabilities[:name] = 'Testing Selenium 2 with Ruby on BrowserStack'
      capabilities['os'] = selenium_os
      capabilities['os_version'] = selenium_os_version
      capabilities['browser'] = selenium_browser
      capabilities['browser_version'] = selenium_browser_version
      capabilities['browserstack.user'] = selenium_username
      capabilities['browserstack.key'] = selenium_apikey
      capabilities['browserstack.debug'] = 'true'
      capabilities['acceptSslCerts'] = 'true'
      capabilities['Idle timeout'] = 30
      capabilities['build'] = ENV['BUILD_NUMBER']
      capabilities['project'] = ENV['JOB_NAME']
      capabilities
    end
    def self.url
      'http://hub.browserstack.com/wd/hub'
    end

    def self.init_browser(scenario)
      my_capabilities = capabilities()
      my_url = url()
      my_capabilities[:name] = name_from_scenario(scenario)
      @browser = nil
      count=0
      try_count=0

      #check for session limit before starting the test
      wait_till_session_is_available()

      WaitUntil::wait_until(500) do
        count+=1
        puts "try #{count} to init browser" if count>1

        begin
          try_count+=1
          @browser = Selenium::WebDriver.for(:remote, :url => my_url, :desired_capabilities => my_capabilities)
          @browser.get @test_url
          raise "Network connection issue. Failed to open #{@test_url} and find '#{@test_substring}' substring" if !@browser.page_source.downcase.include? @test_substring
          @browser
        rescue =>e
          if e.message.include? 'sessions are currently being used. Please upgrade to add more parallel sessions'
            puts "Run out of sessions: '#{e.message}'"
          else
            puts "Exception while initializing Selenium session: #{e.class }#{e}"
            puts e.backtrace
            @browser.quit if !@browser.nil?
            raise if try_count>30
          end
        end
      end

      if @browser.nil?
        puts 'failed to init browser'
        raise 'failed to initiate remote browser session after 300 seconds'
      end

      unless @browser.is_a? ::Selenium::WebDriver::Driver
        puts 'invalid browser'
        raise 'invalid browser'
      end

      @browser.instance_variable_get(:'@bridge').maximizeWindow
      #puts my_capabilities['name']
      #puts @browser.session_id
      ENV['browser_session_id'] = @browser.session_id
      @browser
    end

    def self.wait_till_session_is_available
      ::BrowserStackCucumber::WaitUntil::wait_until(500) do
        url = "https://#{selenium_username}:#{selenium_apikey}@api.browserstack.com/3/status"
        r = RestClient.get(url)
        parsed_r = JSON.parse(r.body)
        puts "no free BrowserStack session available now#{parsed_r}" if (parsed_r['sessions_limit']==parsed_r['running_sessions'])
        parsed_r['sessions_limit']-parsed_r['running_sessions']>0
      end
    rescue RestClient::Unauthorized=>e
      puts "Error: Failed to access BrowserStack account, please check username and api key: #{e}"
      raise
    end

    def self.browser
      @browser
    end

    def self.close_browser
      @browser.quit if !@browser.nil?
      @browser = nil
    end

    def self.close_browser_force
      unless @browser.nil?
        puts @browser.title
        STDERR.puts 'Something went wrong and selenium session was not closed. Closing it now.'
        ::BrowserStackCucumber::Config.close_browser
      end

    end

  end


  module_function
  def before_hook_impl
    #::Capybara.default_driver = :browser_stack
    #::Capybara.current_driver = :browser_stack
    @browser = BrowserStackCucumber::Config.browser
  end

  module_function
  def around_hook_impl(scenario, block)
    #::Capybara.current_driver = :browser_stack

    #set additional job details here (project, build, name etc)
    #init selenium session

    #driver = ::Capybara.current_session.driver
    #noinspection RubyUnusedLocalVariable
    my_browser = BrowserStackCucumber::Config.init_browser(scenario)

    #set sessions details for BrowserStack here
    #Job = ...

    # This allow us to execute steps (n) times
    unless scenario.instance_of? ::Cucumber::Ast::OutlineTable::ExampleRow
      scenario.steps.each do |step|
        step.instance_variable_set(:@skip_invoke, false)
      end
    end

    block.call

    # Quit the driver to allow for the generation of a new session_id
    BrowserStackCucumber::Config.close_browser

    #report job status to BrowserStack
    #unless job.nil?
    #  job.passed = !scenario.failed?
    #  job.save
    #end



  end

  module_function
  def at_exit_impl
    ::BrowserStackCucumber::Config.close_browser_force
    #do global shutdown (i.e. tunnel)
    #check for global errors
  end


end
require "cucumber/formatter/junit"

module BrowserStackCucumber
  class JenkinsFormatter < Cucumber::Formatter::Junit
    def initialize(step_mother, io, options)
      super
    end

    def after_steps(steps)
      @output += job_url unless @in_examples
      super

    end

    def after_table_cell(table_row)
      @output += job_url unless @header_row
    end

    private

    def basename(feature_file)
      filename = super
      "#{filename}_#{Time.now.strftime("%Y-%m-%d-%H%M%S")}_#{Random.rand(9999).to_s}"
    end


    def job_url
      job_id = ENV['browser_session_url']
      "Session url #{job_id}"
    end

  end
end
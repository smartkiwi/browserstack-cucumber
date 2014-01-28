require 'browserstack/version'
require 'browserstack/browserstack'

require 'browserstack/jenkins_formatter'

# Extend Cucumber's builtin formats, so that this
# formatter can be used with --format browserstack_jenkins
require 'cucumber/cli/main'

Cucumber::Cli::Options::BUILTIN_FORMATS["browserstack_jenkins"] = [
    "BrowserStackCucumber::JenkinsFormatter",
    "BrowserStack Jenkins JUnit report formatter"
]



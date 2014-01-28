class YahooResultsPage
  include PageObject

  expected_title 'why yahoo changed the logo - Yahoo Search Results'

  def search_results
    @browser.find_elements(css: 'li > div > div > h3 > a')
  end

  def initialize_page
    #has_expected_title_wait? if self.respond_to?("has_expected_title_wait?")

    has_expected_title? if self.respond_to?('has_expected_title?')

    #has_expected_element? if self.respond_to?("has_expected_element?")

    #has_expected_element_visible? if self.respond_to?("has_expected_element_visible?")


  end


end